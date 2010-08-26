Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0HZV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:27:18 -0400
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:29055 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754187Ab0HZV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:27:15 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: FrK22WMVM1nv5z_nzOVQJrRj3Wp8erNpo.ii4seA4b6NZRc
 yrPGR_aSbNnqY6eFWraqh1.eSCzSbY5YgDvTu_u5UfKxSWB08NY1s2.IZRdl
 xTOby294jMoMh4nSoQZxcSMMw5zrrIPlKmItc216FghSCVbhw4GS4rm6T_aN
 ysQnX0h4z.QVk4dBIM1wKQ_5JrwGfY6gx9XdNI_f6rRcwKDOxDvP6Ii4kFVt
 OWPnqUppFmY8ZffbuxRSVaUGw.SBWY3zh8mxOl4jzcFubMOFfmhhrNszFU0o
 FrtatlHnS7igKm35.7J_jnKw-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C76CA57.3050405@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>
	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>
	 <4C7421FB.2060007@vlnb.net>
	 <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
	 <4C76CA57.3050405@vlnb.net>
Content-Type: text/plain
Date: Thu, 26 Aug 2010 14:23:26 -0700
Message-Id: <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 00:11 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 08/25/2010 01:23 AM wrote:
> > As mentioned explictly earlier in this thread, my WIP code for the
> > kernel level subsystem backstore using STGT kernel<->  user CDB
> > passthrough logic in drivers/target/target_core_stgt.c is a item on
> > my TODO list, but I will repeat, is NOT being tagged as a mainline
> > .37 item.
> 
> Hmm, I can't understand, if target_core_stgt.c is "NOT being tagged as a 
> mainline .37 item", then the STGT ABI compatibility for being a drop in 
> replacement for STGT isn't a requirement? Or am I missing something?
> 

Sorry, but I have no idea what you are trying to conjour up here.

To spell out (again) the TCM/LIO<->STGT compatibility stages that have
been persued pubically over the last months:

I) Create proper userspace tgt.git SG_IO and BSG passthrough into   
   TCM_Loop v4 using high-level multi-fabric WWPN emulation so that TCM 
   Core SPC-4 kernel emulation is exposed to STGT user fabrics, eg: 
   userspace fabric module -> kernel backstore passthrough.  (DONE 
   for .37, and STGT passthrough + BSG backstore support merged into 
   tgt.git by Tomo-san)

II) Complete target_core_stgt.c TCM subsystem plugin for kernel -> user 
    CDB -> LUN passthrough building upon existing 
    drivers/scsi/scsi_tgt_*.c code.  (WIP for .38, made available 
    initially as a seperate standalone .ko module in lio-core-2.6.git)

> > Tomo-san, mnc, and other storage folks have been briefed on the
> > remaining issues that would be involved to get a prototype
> > functioning with drivers/target/target_core_stgt.c, and rough idea of
> > what it would take in existing mainline drivers/scsi/scsi_tgt_*.c
> > code.  With the current WIP code this will allow the userspace CDB ->
> > LUN passthrough to function transparently with all TCM SPC-4
> > compliant logic as a standalone struct se_subsystem_api
> > tcm_core_stgt.ko backstore.
> 
> This is exactly what we are discussing.

Then I suggest you start working on a patch for drivers/scsi/scsi_tgt_*
in order to address what you believe are the preceived shortcomings of
the original design.

Until you can do that, and actually take an impartial look at the
existing drivers/scsi/scsi_tgt_*.c,  it would be a bit difficult to
beleive you genuinely want to steer our current level of interaction
away from continued hand-waving noise into a real rational technical
discourse between yourself and the LIO/STGT development community.

Best,

--nab

