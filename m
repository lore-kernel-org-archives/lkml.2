Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1KJVVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:21:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39853 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab1KJVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:21:53 -0500
Message-ID: <4EBC406D.8010404@garzik.org>
Date: Thu, 10 Nov 2011 16:21:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
References: <20111109162512.GB1260@google.com>
In-Reply-To: <20111109162512.GB1260@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 11:25 AM, Tejun Heo wrote:
> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
>
> The commit introduced alias for block devices which is intended to be
> used during logging although actual usage hasn't been committed yet.
> This approach adds very limited benefit (raw log might be easier to
> follow) which can be trivially implemented in userland but has a lot
> of problems.
>
> It is much worse than netif renames because it doesn't rename the
> actual device but just adds conveninence name which isn't used
> universally or enforced.  Everything internal including device lookup
> and sysfs still uses the internal name and nothing prevents two
> devices from using conflicting alias - ie. sda can have sdb as its
> alias.
>
> This has been nacked by people working on device driver core, block
> layer and kernel-userland interface and shouldn't have been
> upstreamed.  Revert it.
>
>   http://thread.gmane.org/gmane.linux.kernel/1155104
>   http://thread.gmane.org/gmane.linux.scsi/68632
>   http://thread.gmane.org/gmane.linux.scsi/69776
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Jens Axboe<axboe@kernel.dk>
> Cc: "James E.J. Bottomley"<James.Bottomley@HansenPartnership.com>
> Cc: Nao Nishijima<nao.nishijima.xt@hitachi.com>
> Cc: Kay Sievers<kay.sievers@vrfy.org>
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> Cc: Alan Cox<alan@linux.intel.com>
> Cc: Al Viro<viro@zeniv.linux.org.uk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


