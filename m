Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0KBCgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 22:36:31 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:37365 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0KBCg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 22:36:29 -0400
Date: Mon, 1 Nov 2010 19:36:28 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: srajiv@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: suspend fails on x200 (was Re: [PATCH] tpm: Autodetect itpm
	devices)
Message-ID: <20101102023628.GB19250@hexapodia.org>
References: <1287697360-31273-1-git-send-email-mjg@redhat.com> <20101101211948.GA19250@hexapodia.org> <20101101213224.GA28746@srcf.ucam.org> <20101102013106.GX5988@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102013106.GX5988@hexapodia.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 06:31:06PM -0700, Andy Isaacson wrote:
> On Mon, Nov 01, 2010 at 09:32:24PM +0000, Matthew Garrett wrote:
> > On Mon, Nov 01, 2010 at 02:19:48PM -0700, Andy Isaacson wrote:
> > > I suspect that it would have failed previously if I'd forced the module
> > > to load, but since tpm_tis now loads automatically as of 2.6.37-rc1, I
> > > have to "rmmod tpm_tis" for suspend to work.
> > 
> > Hm. That's what this patch was intended to fix. Can you check that the 
> > tree you're using has it merged? The autoloading comes from the fix to 
> > the pnp code to use _CID even if _HID is malformed, so now we have a pnp 
> > device when we previously didn't.
> 
> Hmmm, I am testing with straight-up .37-rc1, c8ddb2713c62.  It does not
> include your patch.
> 
> This time around, still running -rc1, I ran pm-suspend and it suspended
> + resumed fine.  The second time I ran pm-suspend, it switched to text
> console and started flashing the moon LED, but hung there with the LCD
> backlight still on and the LED moon flashing.
> 
> So, definitely something exciting going on... and not a simple
> suspend regression, and definitely not caused by this patch, my
> apologies.  Subject line updated accordingly.
> 
> I'll try applying "Autodetect itpm devices" and report back.

With your patch applied on top of -rc1, suspend + resume seems to work
fine, and I don't have any error messages from tpm in dmesg.

Thanks, problem solved.  (Still no idea what caused that one
hang-with-blinking-moon, but it doesn't appear to be connected.)

-andy
