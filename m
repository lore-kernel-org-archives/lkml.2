Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2FUAGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:06:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49749 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758630Ab2FUAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:06:34 -0400
X-Sasl-enc: zCEp2oMcIrIc1N18RpQTxbe6V/DucJ6IC+a652m6TxWW 1340237193
Date: Wed, 20 Jun 2012 21:06:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120621000631.GH4223@khazad-dum.debian.net>
References: <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
 <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
 <20120619102250.GA787@aftab.osrc.amd.com>
 <1340101568.21745.37.camel@twins>
 <20120619182228.GA18816@khazad-dum.debian.net>
 <4FE0DF9F.10401@zytor.com>
 <20120620234651.GD4223@khazad-dum.debian.net>
 <4FE26182.5070107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE26182.5070107@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, H. Peter Anvin wrote:
> On 06/20/2012 04:46 PM, Henrique de Moraes Holschuh wrote:
> > Well, it makes the kernel tell us what (amd/intel/whatever) firmware it
> > wants, and requires (after patching) a simple echo 1 >foo to activate.  It
> > is also harmless if activated without updated firmware in place.
> > 
> > /dev/cpu/microcode requires special software (or a dd with bs>=file size),
> > since it borks if userspace breaks a microcode into two write() syscalls,
> > and requires detection of the cpu vendor.  Very annoying.
> > 
> 
> Yeah, because dd is such an exotic piece of software...

No, because dd if=<whatever> of=/dev/cpu/microcode bs=1M means I have to
add dd to the initramfs or to busybox, AND it will break the day the
microcode data file gets bigger than 1M.  And it will be at best very
annoying to have to special case each vendor to locate the correct
microcode, etc.

I'll take the firmware interface we already have to support to get
anything done with a lot of other drivers anyway, thank you very much.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
