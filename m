Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1KKRkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:40:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab1KKRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:40:25 -0500
Date: Fri, 11 Nov 2011 09:36:33 -0800
From: Greg KH <gregkh@suse.de>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Message-ID: <20111111173633.GA24351@suse.de>
References: <20111109162512.GB1260@google.com>
 <4EBD361E.5040106@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EBD361E.5040106@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 11:50:06PM +0900, Nao Nishijima wrote:
> Hi,
> 
> Finally, I understood why this patch is not acceptable and would like to
> solve the problem of the device name mismatch in *user space* using
> udev. So, could you please give me your comment about it?
> 
> I aim to unify the device name because the name shown in command output
> is different from it that users use for command execution.
> 
> So, I'd like to suggest that two new API should be added to udev.
> - The API that returns any symlinks such as by-uuid, by id that users
>   selected before if a device name is given as arguments
>   If the commands directly access to proc filesystems, they cannot get
>   the symlinks. These commands should get the device name via this API.
> - The API that replaces device name to symlink in text messages
> 　　The dmesg and syslog messages include the raw device names such as
>   sdX. They should be replaced with symlinks to unify the device names.
> - udev support alias
>   Symlinks (by-uuid, by-id …) is too long, compared to before (e.g.
>   sdX). I guess most of users need more friendly and short names.
> 
> Could you give me some advice or comments?
> (I will post this idea udev mailing list with prototype code)

Patches are always best to work off of, please post your changes to udev
to the linux-hotplug list and we can take it from there.

thanks,

greg k-h
