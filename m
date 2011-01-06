Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1AFKsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1AFKsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:48:18 -0500
Date: Thu, 6 Jan 2011 11:48:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110106104816.GA4026@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
[...]
> We did have another revert to fix hopefullythe last "blank screen"
> regression on intel graphics.

It seems that there is still a regression for intel graphic cards
backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
I can reproduce the problem easily by:
xset dpms force standby; sleep 3s; xset dpms force on

backlight doesn't get up (there is really dark picture though which
doesn't get brighter by function keys which work normally) after dpms on
until I close and open lid. 

The problem wasn't present in 2.6.36

$ lspci -vv
[...]
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
        Subsystem: Fujitsu Limited. Device 137a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0300000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at 1800 [size=8]
        Region 2: Memory at e0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at f0400000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
[...]
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
