Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2LLKvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:51:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49209 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2LLKvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:51:46 -0500
Date: Wed, 12 Dec 2012 11:51:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mengdong Lin <mengdong.lin@intel.com>
Subject: Re: pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50
 [snd_hda_intel] returns -11
Message-ID: <20121212105143.GA9252@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
	lkml <linux-kernel@vger.kernel.org>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Mengdong Lin <mengdong.lin@intel.com>
References: <20121211170315.GC28827@liondog.tnic>
 <2487425.bAQggRZzC4@vostro.rjw.lan>
 <20121211175508.GE28827@liondog.tnic>
 <15066310.xXEWfqCuJc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15066310.xXEWfqCuJc@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 12:44:33AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, December 11, 2012 06:55:08 PM Borislav Petkov wrote:
> > On Tue, Dec 11, 2012 at 06:48:23PM +0100, Rafael J. Wysocki wrote:
> > > Boris, please send the output of "lspci -vvv' from that box.
> > 
> > Attached.
> 
> So the audio is a Root Complex Integrated Endpoind and there shouldn't be
> any problems with it related to PCIe ports power management.
> 
> It looks like azx_runtime_suspend() is new in 3.7 and it returns -EAGAIN
> to indicate that it actually can't be suspended (if my understanding the
> code is correct).  However, it shouldn't do that, because that causes
> the runtime PM core to repeat the attempts.  It rather should implement
> a .runtime_idle() callback returning an error code instead.
> 
> Those messages are just noise, though.

Adding author of this (b8dfc4624162c0547d7f36a9df48da2d9b4bd58a).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
