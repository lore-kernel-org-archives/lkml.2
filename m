Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1HWSM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:12:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:26675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1HWSMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41069505"
Date: Tue, 23 Aug 2011 11:12:11 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: sifram rajas <sifram.rajas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] xhci: Redundant check for xhci->devs[]
Message-ID: <20110823181211.GA7539@xanatos>
References: <CA+OjSzww54ogPKD4PuKR6=37fbTBwnWq5yw2NSTZM0pH1N8S1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OjSzww54ogPKD4PuKR6=37fbTBwnWq5yw2NSTZM0pH1N8S1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sifram,

Unfortunately, I can't apply this message as a patch the way you sent
it.  Can you try to resend this with a couple of modifications?

The first thing to note is that you should never include an extra
message after the diff.  Your "thanks" line will cause this to not
apply.  If you ever do need to add a note that you don't want to include
in the patch description for git log, you can stick it in between the
--- line and the first file path diff line, like so:


Signed-off-by: Sifram Rajas <sifram.rajas@gmail.com>
---

This is a message that will never be shown by `git log`.

drivers/usb/host/xhci.c |   3 +--
1 files changed, 1 insertions(+), 2 deletions(-)


You can also do fancier things, like using the "scissors" line to
include a message above the description, which git-am will ignore, but
most people don't use that.

Second, the body of your email will get recorded as the patch
description in git, including the "Hi Sarah" bit and sentence about what
patch this applies to.  You probably don't want those to show up in the
git history. :)

Are you using git to commit your changes and then `git format-patch` to
create a mail to send?  That's often easier than adding a patch
description by hand in your email client, because you can use `git show
HEAD` to see exactly how your patch is going to show up in the git log.

Third, there's no need to tell me which kernel this applies to (either
Linus' tree or Greg's tree should work fine).  People might want to
apply your patch to stable trees, so it is a bit confusing to list which
version this patch applies to in the patch description.  If you need to
do that for someone else, you should put the version number in between
the square brackets of the subject line, like

Subject: [PATCH 3.0.3] xhci: Redundant check for xhci->devs[]

Anything in square brackets is ignored by git-am, so it won't show up in
the patch short description.

Can you resend this patch?

Thanks,
Sarah Sharp

On Mon, Aug 22, 2011 at 09:06:59PM +0530, sifram rajas wrote:
> Hi Sarah,
> 
> This patch is for linux-3.0.3.
> 
> In the xhci_check_args() function in xhci.c, there is a redundant
> check for xhci->devs.
> 
> This is redundant because the struct xhci_hcd->devs is actually
> defined as a static array
> of pointers and is not a pointer to a pointer.
> 
> Signed-off-by: Sifram Rajas <sifram.rajas@gmail.com>
> ---
> drivers/usb/host/xhci.c |   3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> --- a/drivers/usb/host/xhci.c   2011-08-17 23:27:16.000000000 +0530
> +++ b/drivers/usb/host/xhci.c   2011-08-22 20:43:34.250000000 +0530
> @@ -945,8 +945,7 @@ static int xhci_check_args(struct usb_hc
>                return -ENODEV;
> 
>        if (check_virt_dev) {
> -               if (!udev->slot_id || !xhci->devs
> -                       || !xhci->devs[udev->slot_id]) {
> +               if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
>                        printk(KERN_DEBUG "xHCI %s called with unaddressed "
>                                                "device\n", func);
>                        return -EINVAL;
> 
> Thanks,
> Sifram Rajas.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
