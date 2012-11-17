Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2KQP3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 10:29:24 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54907 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab2KQP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 10:29:22 -0500
X-Sasl-enc: MEwmvE9QxPc32qu2z+sfLaV9XDfpK3e/JTxhkn7y3D3p 1353166162
Date: Sat, 17 Nov 2012 13:29:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, Gene Heskett <gheskett@wdtv.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, herrmann.der.user@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121117152918.GA16697@khazad-dum.debian.net>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
 <20121115204503.GB18032@khazad-dum.debian.net>
 <201211151801.23160.gheskett@wdtv.com>
 <50A57C35.10906@amd.com>
 <20121117144117.GD16441@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121117144117.GD16441@x1.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012, Borislav Petkov wrote:
> On Thu, Nov 15, 2012 at 06:35:17PM -0500, Boris Ostrovsky wrote:
> > One possibility is that BIOS already incorporated all patches (which
> > typically is the case) and so the driver doesn't have to do anything.
> 
> /proc/cpuinfo contains ucode version and the processor's f/m/s, which
> is enough information to tell us whether your old phenom needs ucode
> patching.

Maybe, however F/M/S information is incomplete, not to mention trying to
rebuild the proper processor signature from it is anything but
forward-proof.  For Intel, it is also useless, you also need the processor
flags...

If /proc/cpuinfo is to be useful for microcode purposes, it should add a
microcode signature line, with CPUID(1).EAX, and on Intel processors, also a
second parameter with the processor flags mask (I don't know if AMD needs
something else other than CPUID(1).EAX).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
