Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2D1JFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:05:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34547 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2D1JFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:05:30 -0400
Date: Sat, 28 Apr 2012 11:05:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120428090523.GD26065@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
 <20120427133304.GE9626@aftab.osrc.amd.com>
 <4F9ABCEC.9090807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9ABCEC.9090807@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:36:12PM -0300, Mauro Carvalho Chehab wrote:
> The fix for it were in another patch[1], as calling them as "rank" is
> needed also at the sysfs API.

No, this doesn't fix it either:

[   10.486440] EDAC MC: DCT0 chip selects:
[   10.486443] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   10.486445] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   10.486448] EDAC amd64: MC: 4:     0MB 5:     0MB
[   10.486450] EDAC amd64: MC: 6:     0MB 7:     0MB
[   10.486453] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00000088
[   10.486455] EDAC MC: DCT1 chip selects:
[   10.486458] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   10.486460] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   10.486463] EDAC amd64: MC: 4:     0MB 5:     0MB
[   10.486465] EDAC amd64: MC: 6:     0MB 7:     0MB
[   10.486467] EDAC amd64: using x8 syndromes.
[   10.486469] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00083100
[   10.486472] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
[   10.486475] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
[   10.486478] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
[   10.486481] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: yes L1: yes L2: no L3: no
[   10.486485] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
[   10.486488] EDAC amd64: MCT channel count: 2
[   10.486493] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc(): allocating 3692 bytes for mci data (16 ranks, 16 csrows/channels)
[   10.486501] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   10.486506] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 1: rank1 (0:1:0): row 0, chan 1
[   10.486510] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 2: rank2 (1:0:0): row 1, chan 0
[   10.486514] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 3: rank3 (1:1:0): row 1, chan 1
[   10.486518] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 4: rank4 (2:0:0): row 2, chan 0
[   10.486522] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 5: rank5 (2:1:0): row 2, chan 1
[   10.486526] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 6: rank6 (3:0:0): row 3, chan 0
[   10.486530] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 7: rank7 (3:1:0): row 3, chan 1
[   10.486534] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 8: rank8 (4:0:0): row 4, chan 0
[   10.486538] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 9: rank9 (4:1:0): row 4, chan 1
[   10.486542] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 10: rank10 (5:0:0): row 5, chan 0
[   10.486546] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 11: rank11 (5:1:0): row 5, chan 1
[   10.486550] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 12: rank12 (6:0:0): row 6, chan 0
[   10.486554] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 13: rank13 (6:1:0): row 6, chan 1
[   10.486558] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 14: rank14 (7:0:0): row 7, chan 0
[   10.486562] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 15: rank15 (7:1:0): row 7, chan 1

DCT0 has 4 ranks + DCT1 also 4 ranks = 8 ranks total.

Now your change is showing 16 ranks. Still b0rked.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
