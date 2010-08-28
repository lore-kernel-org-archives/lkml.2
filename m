Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0H1Uvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:51:38 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:29249 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752432Ab0H1Uvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:51:36 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 3_JFlY8VM1loai8JWcC_H4.0XYFyrZYZozx7OOTsVEIeocm
 pLY5vmZjPQTLTxW7nLwGgOcRfoFiyiNS1idwk.eVAtkqfRdXKwvEmAPy60lW
 C3G42t.MxmO7xpK9e_q_olqf8GSyYr..z30JPQtVG..Ep7PEeZ_izzuOQcOF
 HzUr.fZ0WEkLf570colqV9bpTuqICvDPSvUswVWQ92HLW8rSRiYd8Til8SNw
 CgC9OryYAo1HEDTrN0TRp2qHaqWjHM3iqxf2WBW9yKqCCr0w97WfCKr.ibvm
 wCY0sVuJLHKpyIdVewsxb5d4-
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
In-Reply-To: <4C79484B.3090607@vlnb.net>
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
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
Content-Type: text/plain
Date: Sat, 28 Aug 2010 13:47:48 -0700
Message-Id: <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 21:32 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 08/27/2010 01:23 AM wrote:
> >> Nicholas A. Bellinger, on 08/25/2010 01:23 AM wrote:
> >>> As mentioned explictly earlier in this thread, my WIP code for the
> >>> kernel level subsystem backstore using STGT kernel<->   user CDB
> >>> passthrough logic in drivers/target/target_core_stgt.c is a item on
> >>> my TODO list, but I will repeat, is NOT being tagged as a mainline
> >>> .37 item.
> >>
> >> Hmm, I can't understand, if target_core_stgt.c is "NOT being tagged as a
> >> mainline .37 item", then the STGT ABI compatibility for being a drop in
> >> replacement for STGT isn't a requirement? Or am I missing something?
> >
> > Sorry, but I have no idea what you are trying to conjour up here.
> >
> > To spell out (again) the TCM/LIO<->STGT compatibility stages that have
> > been persued pubically over the last months:
> >
> > I) Create proper userspace tgt.git SG_IO and BSG passthrough into
> >     TCM_Loop v4 using high-level multi-fabric WWPN emulation so that TCM
> >     Core SPC-4 kernel emulation is exposed to STGT user fabrics, eg:
> >     userspace fabric module ->  kernel backstore passthrough.  (DONE
> >     for .37, and STGT passthrough + BSG backstore support merged into
> >     tgt.git by Tomo-san)
> >
> > II) Complete target_core_stgt.c TCM subsystem plugin for kernel ->  user
> >      CDB ->  LUN passthrough building upon existing
> >      drivers/scsi/scsi_tgt_*.c code.  (WIP for .38, made available
> >      initially as a seperate standalone .ko module in lio-core-2.6.git)
> 
> That would mean that if LIO merged in .37:
> 
> 1. It would be merged _without_ STGT ABI compatibility, i.e. one of the 
> requirements for a new SCSI target infrastructure merge is violated.
> 

Sorry, but you are completely wrong here.  This has nothing to do with a
question of STGT kernel 'ABI compatibility' (because there is only one
mainline user!), but has everything to do with being able to expose TCM
kernel level SPC-4 emulation, and make this logic available to existing
userspace fabrics in tgt.git.  Again, we are talking about userspace
STGT fabric module <-> TCM kernel backstore support for .37, which has
already been merged by into tgt.git, and being used by other STGT users
for SG_IO and BSG passthrough.

> 2. It would _not_ be a drop in replacement for STGT, because STGT's 
> drivers/scsi/scsi_tgt_*.c code would stay in the kernel. Those would 
> effectively mean that another requirement for a new SCSI target 
> infrastructure merge would be violated: there would be 2 SCSI target 
> infrastructures in the kernel and any STGT in-kernel driver (for 
> instance, built as an outside module) would continue working. My 
> understanding of "drop in replacement" is "one out, another in at once".
> 

Sorry, but this is just more generic handwaving on your part.  What
constitutes a 'drop in replacement' for STGT is a decision that was to
be made by the STGT developers, not by you.  target_core_stgt.c is an
extraordinarly transparent method of bringing drivers/scsi/scsi_tgt_*
logic into the TCM Core HBA/DEV design, and allows us to build upon and
improve the existing mainline kernel code.

> Please tell me where I'm wrong? I would appreciate if you be precise and 
> answer the above 2 my concerns. There is no point to again repeat what 
> you have already written without adding any new information.
> 
> >>> Tomo-san, mnc, and other storage folks have been briefed on the
> >>> remaining issues that would be involved to get a prototype
> >>> functioning with drivers/target/target_core_stgt.c, and rough idea of
> >>> what it would take in existing mainline drivers/scsi/scsi_tgt_*.c
> >>> code.  With the current WIP code this will allow the userspace CDB ->
> >>> LUN passthrough to function transparently with all TCM SPC-4
> >>> compliant logic as a standalone struct se_subsystem_api
> >>> tcm_core_stgt.ko backstore.
> >>
> >> This is exactly what we are discussing.
> >
> > Then I suggest you start working on a patch for drivers/scsi/scsi_tgt_*
> > in order to address what you believe are the preceived shortcomings of
> > the original design.
> >
> > Until you can do that, and actually take an impartial look at the
> > existing drivers/scsi/scsi_tgt_*.c,  it would be a bit difficult to
> > beleive you genuinely want to steer our current level of interaction
> > away from continued hand-waving noise into a real rational technical
> > discourse between yourself and the LIO/STGT development community.
> 
> My look is completely impartial. With all my respect, I'm just quite 
> ahead of you and can see what you are unable (or don't want?) to see. I 
> did what you are currently doing almost 4 years ago. I have already 
> written all the necessary code and addressed all _rose on practice_ 
> concerns.

It is obvious to even an casual observer from watching the TCM/LIO patch
series that have been flying across the linux-scsi wire the last 24
months that the major features (including PR and ALUA, and new fabric
module drivers) have been developed individual feature bit by feature
bit using a distributed git workflow in a bisectable manner.  Each
series was produced in such a manner that each patch could be reviewed
individually by those interested parties.

This is the big difference between our respective development processes.
This is the case not only for SCSI feature bits that TCM/LIO and SCST
share, but for features in TCM/LIO v4 that are unique and not available
in any other target implemention, anywhere.  And yes, I am most
certainly talking about code beyond just the SCSI level fabric emulation
bits you are mentioning above.

> But all my attempts to explain my view are just blindly 
> ignored without any considerations, so I have no idea how more I can 
> explain it.
> 

Then I suggest you learn a better way of communicating your ideas if you
really want to work with members of the LIO/STGT development
communities.

First, I suggest you start explaining your ideas with actual kernel code
that is 1) human readable and 2) presented in such a manner that makes
it accessable for others with skills possibly different (and greater)
than your own to review and give feedback.

Best,

--nab

