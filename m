Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0G1Sa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:30:28 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59315 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0G1Sa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:30:26 -0400
Date: Wed, 28 Jul 2010 20:30:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 0/3] update of various kbuild flags to allow user
	settings
Message-ID: <20100728183024.GD29232@merkur.ravnborg.org>
References: <20100728182523.GA29198@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728182523.GA29198@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 08:25:23PM +0200, Sam Ravnborg wrote:
> Denys Vlasenko complained that he could not set
> a moduel specific linker flags on the command line.
> 
> It turned out that the cause of this was kbuild
> that assigned a value to a variables that
> may be modified by the user.
> So any user supplied value would overwrite
> the kbuild assigned value.
> 
> Fix this so we use internal variables for kbuild
> feering up the official variables for use by
> the user.
> 
> Changes in v2:
> Fix so we can now specify both module and built-in
> options on command line.
> Combine all *_MODULE changes in one patch.
> Add a new patch for *_KERNEL changes.
> Document the new variables in makefiles.txt
> Document the variables that may be set on the command line
> in kbuild.txt
> 
> The frv Makefile saw a bigger cleanup this time.
> I suggest to merge it through kbuild.git because the
> update is dependent on the first patch in this serie.

Forgot the stats:


Sam Ravnborg (3):
      kbuild: allow assignment to {A,C,LD}FLAGS_MODULE on the command line
      kbuild: allow assignment to {A,C}FLAGS_KERNEL on the command line
      frv: clean up arch/frv/Makefile

 Documentation/kbuild/kbuild.txt    |   26 ++++++++++++++++++++++++--
 Documentation/kbuild/makefiles.txt |   27 ++++++++++++++++++++++-----
 Makefile                           |   17 ++++++++++++-----
 arch/avr32/Makefile                |    2 +-
 arch/blackfin/Makefile             |    4 ++--
 arch/frv/Makefile                  |   22 ++--------------------
 arch/ia64/Makefile                 |    6 +++---
 arch/m32r/Makefile                 |    4 ++--
 arch/m68k/Makefile                 |    2 +-
 arch/mips/Makefile                 |    6 ++++--
 arch/powerpc/Makefile              |    2 +-
 arch/s390/Makefile                 |    3 ++-
 arch/score/Makefile                |    3 ++-
 scripts/Makefile.build             |   11 +++++++----
 scripts/Makefile.modpost           |    7 ++++---
 15 files changed, 89 insertions(+), 53 deletions(-)

