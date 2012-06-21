Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2FUCdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:33:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47610 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab2FUCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:33:31 -0400
X-Sasl-enc: VNcwvKCIts+Jrpq6m841C21KBe4fOfVn7XczSUoStO// 1340246010
Date: Wed, 20 Jun 2012 23:33:27 -0300
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
Message-ID: <20120621023327.GA16269@khazad-dum.debian.net>
References: <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
 <20120619102250.GA787@aftab.osrc.amd.com>
 <1340101568.21745.37.camel@twins>
 <20120619182228.GA18816@khazad-dum.debian.net>
 <4FE0DF9F.10401@zytor.com>
 <20120620234651.GD4223@khazad-dum.debian.net>
 <4FE26182.5070107@zytor.com>
 <20120621000631.GH4223@khazad-dum.debian.net>
 <4FE2683E.4060707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE2683E.4060707@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, H. Peter Anvin wrote:
> On 06/20/2012 05:06 PM, Henrique de Moraes Holschuh wrote:
> > No, because dd if=<whatever> of=/dev/cpu/microcode bs=1M means I have to
> > add dd to the initramfs or to busybox, AND it will break the day the
> > microcode data file gets bigger than 1M.  And it will be at best very
> > annoying to have to special case each vendor to locate the correct
> > microcode, etc.
> 
> No.
> 
> The whole point is you won't have to put ANYTHING in your initramfs,
> period.  The early microcode blob will be all you need there.

Yes.  And the sooner it gets done that way, the better.  But until then, IMO
the firmware_request + sysfs trigger interface is easier and friendler to
use than /dev/cpu/microcode.

> So the only issue left is what to do when you want to update the
> microcode in an already running system.

Well, IMO the firmware interface makes that somewhat easier on the userland
side, as it is more userfriendly from a generic support for processor
microcode updates point-of-view.  And the sysfs trigger isn't that horrible,
it is certainly easier to script than an ioctl or syscall.

I guess it's better if we just agree to disagree on this...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
