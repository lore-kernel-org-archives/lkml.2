Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2JINVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:21:07 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37796 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2JINU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:20:56 -0400
Date: Tue, 9 Oct 2012 15:20:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86, RAS: Add a barebones RAS subtree
Message-ID: <20121009132042.GD26450@aftab.osrc.amd.com>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
 <1349716293-16723-2-git-send-email-bp@amd64.org>
 <CA+8MBb+LgCSmV_J-ZeRXuBF_F3qPvUzkvYCC9vo7mugGDNSG7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+LgCSmV_J-ZeRXuBF_F3qPvUzkvYCC9vo7mugGDNSG7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:53:46PM -0700, Tony Luck wrote:
> On Mon, Oct 8, 2012 at 10:11 AM, Borislav Petkov <bp@amd64.org> wrote:
> > +config X86_RAS
> > +       def_bool y
> > +       prompt "X86 RAS features"
> > +       ---help---
> > +       A collection of Reliability, Availability and Serviceability software
> > +       features which enable hardware error logging and reporting. Leave it
> > +       at 'y' unless you really know what you're doing.
> > +
> 
> The intent of "X86_RAS" is just to show/hide all the menu
> options for the individual features - which will all use
>           depends on X86_RAS
> right? Having this set to "y" doesn't actually enable any of
> the features - they all have their own CONFIG_* variables.
> 
> Perhaps we could make that clearer in the help text? And
> ditch the "Leave it at 'y' ... ", I don't think it helps anyone.

Good point. I've changed it to a simple bool which opens a submenu when
enabled (diff ontop):

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 85f666390b5e..d39c2fc20a81 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -688,12 +688,10 @@ config X86_CYCLONE_TIMER
        depends on X86_SUMMIT
 
 config X86_RAS
-       def_bool y
-       prompt "X86 RAS features"
+       bool "X86 RAS features"
        ---help---
        A collection of Reliability, Availability and Serviceability software
-       features which enable hardware error logging and reporting. Leave it
-       at 'y' unless you really know what you're doing.
+       features which enable hardware error logging and reporting.

The def_bool y intent was from earlier but it materialized in a patch
which I sent last week or so which makes CONFIG_X86_MCE enabled by
default so no need to enable those additional RAS stuff by default.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
