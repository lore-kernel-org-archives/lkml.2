Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2EaPNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:13:42 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43194 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab2EaPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:13:41 -0400
Date: Thu, 31 May 2012 17:14:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531151408.GJ14515@aftab.osrc.amd.com>
References: <4FC4E9EB.5030801@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com>
 <20120531100005.GC14074@aftab.osrc.amd.com>
 <4FC748F5.9070709@redhat.com>
 <20120531121741.GB14515@aftab.osrc.amd.com>
 <4FC7788C.1070405@redhat.com>
 <20120531142229.GF14515@aftab.osrc.amd.com>
 <4FC783EA.80704@redhat.com>
 <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC787BF.3020006@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:01:19PM -0300, Mauro Carvalho Chehab wrote:
> Grain is an error property, associated with the error address.
> It is as simple as that. It is not a "change grain frequently" type
> of thing: each address have its associated grain.

... which almost never changes:

5 amd76x_edac.c     amd76x_init_csrows          214 dimm->grain = dimm->nr_pages << PAGE_SHIFT;
6 cpc925_edac.c     cpc925_init_csrows          367 dimm->grain = 32;
7 cpc925_edac.c     cpc925_init_csrows          371 dimm->grain = 64;
8 e752x_edac.c      e752x_init_csrows          1119 dimm->grain = 1 << 12;
9 e7xxx_edac.c      e7xxx_init_csrows           399 dimm->grain = 1 << 12;
k i3000_edac.c      i3000_probe1                416 dimm->grain = I3000_DEAP_GRAIN;
l i3200_edac.c      i3200_probe1                395 dimm->grain = nr_pages << PAGE_SHIFT;
m i5000_edac.c      i5000_init_csrows          1286 dimm->grain = 8;
n i5100_edac.c      i5100_init_csrows           852 dimm->grain = 32;
o i5400_edac.c      i5400_init_dimms           1212 dimm->grain = 8;
p i7300_edac.c      decode_mtr                  662 dimm->grain = 8;
q i7core_edac.c     get_dimm_config             637 dimm->grain = 8;
r i82443bxgx_edac.c i82443bxgx_init_csrows      225 dimm->grain = 1 << 12;
s i82860_edac.c     i82860_init_csrows          180 dimm->grain = 1 << 12;
t i82875p_edac.c    i82875p_init_csrows         388 dimm->grain = 1 << 12;
v i82975x_edac.c    i82975x_init_csrows         430 dimm->grain = 1 << 7;
w mpc85xx_edac.c    mpc85xx_init_csrows         956 dimm->grain = 8;
x mv64x60_edac.c    mv64x60_init_csrows         677 dimm->grain = 8;
y pasemi_edac.c     pasemi_edac_init_csrows     183 dimm->grain = PASEMI_EDAC_ERROR_GRAIN;
z ppc4xx_edac.c     ppc4xx_edac_init_csrows     983 dimm->grain = 1;
A r82600_edac.c     r82600_init_csrows          259 dimm->grain = 1 << 14;
B sb_edac.c         get_dimm_config             597 dimm->grain = 32;
C tile_edac.c       tile_edac_init_csrows       117 dimm->grain = TILE_EDAC_ERROR_GRAIN;
D x38_edac.c        x38_probe1                  394 dimm->grain = nr_pages << PAGE_SHIFT;

>From all possible EDAC grain assignments above, only 3 are not static.

> Ok, on _old_ hardware, this used to be constant, but on modern ones,
> this is associated with the error type, as Tony already explained.

You mean "different" hardware.

> Don't create a crappy API, just because you want to save 32 bits.
> Btw, a "string" grain will spare much more than just 32 bits.

Don't create a bloated API just to fit your purpose because you're
staring at the world through your glasses.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
