Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KAEia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 00:38:30 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53528 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2KAEi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 00:38:29 -0400
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: joeyli <jlee@suse.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
In-Reply-To: <s5h390utqv3.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	 <20121029174131.GC7580@srcf.ucam.org> <s5hobjia6vj.wl%tiwai@suse.de>
	 <20121031173728.GA18615@srcf.ucam.org>  <s5h390utqv3.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Nov 2012 12:21:55 +0800
Message-ID: <1351743715.21227.95.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2012-10-31 於 19:53 +0100，Takashi Iwai 提到：
> At Wed, 31 Oct 2012 17:37:28 +0000,
> Matthew Garrett wrote:
> > 
> > On Wed, Oct 31, 2012 at 06:28:16PM +0100, Takashi Iwai wrote:
> > 
> > > request_firmware() is used for microcode loading, too, so it's fairly
> > > a core part to cover, I'm afraid.
> > > 
> > > I played a bit about this yesterday.  The patch below is a proof of
> > > concept to (ab)use the module signing mechanism for firmware loading
> > > too.  Sign firmware files via scripts/sign-file, and put to
> > > /lib/firmware/signed directory.
> > 
> > That does still leave me a little uneasy as far as the microcode 
> > licenses go. I don't know that we can distribute signed copies of some 
> > of them, and we obviously can't sign at the user end.
> 
> Yeah, that's a concern.  Although this is a sort of "container" and
> keeping the original data as is, it might be regarded as a
> modification.
> 
> Another approach would be to a signature in a separate file, but I'm
> not sure whether it makes sense.
> 

I think it make sense because the private key is still protected by
signer. Any hacker who modified firmware is still need use private key
to generate signature, but hacker's private key is impossible to match
with the public key that kernel used to verify firmware.

And, I afraid we have no choice that we need put the firmware signature
in a separate file. Contacting with those company's legal department
will be very time-consuming, and I am not sure all company will agree we
put the signature with firmware then distribute.


Thanks a lot!
Joey Lee

