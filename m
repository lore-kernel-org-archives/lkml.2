Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0FCIlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:41:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab0FCIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z7ftT5Umb6qkSIHjzwN179ZZArg0NIhFyG30/2SlWrapDCBT33T9UlL7QP6c/LtHvF
         A8nd5np1T/7mPPTfAjh7SfVnnq+Qi+up49O6Kv8MA6+mzOq+LvxmipQ+w7F9dePs03wP
         yDHP1DbZ5Ws1FGQQ3TnAgMNuJ+orqpgp/uypU=
Date: Thu, 3 Jun 2010 12:41:04 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603084104.GA17431@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
 <20100603075402.GA11093@oksana.dev.rtsoft.ru>
 <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 04:11:57PM +0800, Luming Yu wrote:
> On Thu, Jun 3, 2010 at 3:54 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
[...]
> >> I happened to notice that the commit 365cfa1ed5 caused the following
> >> boot error with 2.6.25-rc1
[...]
> > Can you provide full boot log (dmesg) please?
[...]

I don't see any AHCI devices probed.

[...]
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xc9/0x130()
> Hardware name: X8DTN
> sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:1c.4/0000:0f:00.0/slot'

This looks suspicious.

> usb 1-5: New USB device found, idVendor=14dd, idProduct=0002

(...this is async USB stuff, doesn't matter...)

> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.35-rc1 #1
> Call Trace:
>  [<ffffffff8105ed8f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8105ee86>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff811ad969>] sysfs_add_one+0xc9/0x130
>  [<ffffffff811ae0f8>] sysfs_do_create_link+0xd8/0x1a0
>  [<ffffffff811ae1f3>] sysfs_create_link+0x13/0x20
>  [<ffffffff81236466>] pci_create_sysfs_dev_files+0x3d6/0x5f0

Anyway, I just tried to move code around from libahci.c
back to ahci.c by hand, to verify that there are actually
no code changes, and there isn't.

So, I wonder, have you actually bisected the thing correctly?
Does "git reset --hard 365cfa1ed5^" actually help and does
"git reset --hard 365cfa1ed5" actually break things?
