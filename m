Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1ANADS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:03:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1ANADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <20110113141957.1eaf4940@nehalam>
References: <4D2F03F2.4000707@fusionio.com> <AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
 <4D2F51B5.6060105@fusionio.com> <AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
 <20110113141957.1eaf4940@nehalam>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 16:02:12 -0800
Message-ID: <AANLkTikdULkbB83Us_zXivv8Y5FGdHrixUXRiitacaSh@mail.gmail.com>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 2:19 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
>
> It looks my floppy format problem wasn't my patch but the HPET-MSI
> problem. https://patchwork.kernel.org/patch/69588/
>
> Why hasn't that been fixed in mainline kernel?

Because the proper fix was _supposed_ to be the one that disabled MSI
for just the affected AMD boards. See

  commit 73472a46b5b28116b145fb5fc05242c1aa8e1461
  Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
  Date:   Thu Jan 21 11:09:52 2010 -0800

    x86: Disable HPET MSI on ATI SB700/SB800

    HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
    side-effects on floppy DMA. Do not use HPET MSI on such platforms.

    Original problem report from Mark Hounschell
    http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html

    [ This patch needs to go to stable as well. But, there are some
      conflicts that prevents the patch from going as is. I can
      rebase/resubmit to stable once the patch goes upstream.
      hpa: still Cc:'ing stable@ as an FYI. ]

    Tested-by: Mark Hounschell <markh@compro.net>
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Cc: <stable@kernel.org>
    LKML-Reference: <20100121190952.GA32523@linux-os.sc.intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

and if you have the same problem (MSI + floppy doesn't work), can you
give more information about your system?

In particular, is it an AMD southbridge that we don't have listed?
Right now we only trigger it for machines that match this:

  PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS

(which is PCI device 1002:4385) and it may be that we have incomplete coverage.

And so few people use floppies (and expect them to work), that we
probably have very bad test coverage too.

                   Linus
