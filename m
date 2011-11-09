Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1KIRaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:30:09 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395Ab1KIRaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:30:05 -0500
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute
 "alias" in gendisk"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <20111109162512.GB1260@google.com>
References: <20111109162512.GB1260@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 11:30:00 -0600
Message-ID: <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 08:25 -0800, Tejun Heo wrote:
> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
> 
> The commit introduced alias for block devices which is intended to be
> used during logging although actual usage hasn't been committed yet.
> This approach adds very limited benefit (raw log might be easier to
> follow) which can be trivially implemented in userland but has a lot
> of problems.

It has the specific benefit that on snipped logs we don't get a mismatch
between device name and actual device.

We already had this discussion at the kernel summit.  The structured
logging that might give us this facility in userspace isn't there yet
(and may not be for a while), so while users cut and paste logs it's
useful for the logs to show the device preferred name.

With just logs, we can't solve the cross reference problem, since the
cross references appear at different points in the log files.

> It is much worse than netif renames because it doesn't rename the
> actual device but just adds conveninence name which isn't used
> universally or enforced.  Everything internal including device lookup
> and sysfs still uses the internal name and nothing prevents two
> devices from using conflicting alias - ie. sda can have sdb as its
> alias.
> 
> This has been nacked by people working on device driver core,

Which is why it went into gendisk rather than the driver core

> block
> layer and kernel-userland interface and shouldn't have been
> upstreamed.  Revert it.

No, I can't agree with this ... if you propose a working alternative,
I'm listening, but in the absence of one, I think the hack fills a gap
we have in log analysis and tides us over until we have an agreed on
proper solution (at which point, I'm perfectly happy to pull the hack
back out).

James


