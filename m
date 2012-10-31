Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784Ab2JaUOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:14:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704Ab2JaUOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:14:36 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 21:14:36 +0100
Message-ID: <2548314.3caaFsMVg6@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.7.0-rc3-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <20121031171743.GA17652@srcf.ucam.org> <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 17:39:19 Alan Cox wrote:
> On Wed, 31 Oct 2012 17:17:43 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Wed, Oct 31, 2012 at 05:21:21PM +0000, Alan Cox wrote:
> > > On Wed, 31 Oct 2012 17:10:48 +0000
> > > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > > The kernel is signed. The kernel doesn't check the signature on the 
> > > > suspend image.
> > > 
> > > Which doesn't matter. How are you going to create the tampered image in
> > > the first place ?
> > 
> > By booting a signed kernel, not turning on swap and writing directly to 
> > the swap partition.
> 
> Ok so the actual problem is that you are signing kernels that allow the
> user to skip the S4 resume check ?

No. The problem is principal in nature.

swapoff /dev/sdb6 ; dd if=/tmp/malicious_image of=/dev/sdb6 ; sync ; reboot

That would do it on my system.
Maybe in theory you could solve this by the kernel invalidating images
it hasn't written itself and forbidding to change the resume partition from the
kernel command line, but that would break user space hibernation.

	Regards
		Oliver

