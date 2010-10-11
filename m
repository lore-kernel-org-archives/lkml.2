Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0JKUbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:31:03 -0400
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:42796 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756134Ab0JKUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:31:00 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: GsuDhfQVM1lGCdkSmfsrO9QtUXUFd7XxZDt1iVK3JByMUIq
 UX9qNPpsJMpjrNtH1u1EP.DnPD86J3TBxIfMtinHiSSkxuZO7dkZILL_L6Xg
 XMbLxSp7ox.aFIrhIvBo1kWToNCri67Rk.J.ra75VzgWjsyOAyjlBLa4oV5s
 yBBWOtaqPKP4ojo3uOMaNA9TalcoC.yfYJBy.7CWmw6vQq255B06cSksIrKk
 RKXeIclg_CB9n5AEb_LZLUcylP55DMLVY5kEpCuRh2v9otUD2q_i_IotRLZm
 8yoc82nBGWA0crVCz9kGr05DJwg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de,
        James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com,
        jeff@garzik.org
In-Reply-To: <4CB31CAF.7020808@kernel.org>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>
	 <1286340405.5685.93.camel@haakon2.linux-iscsi.org>
	 <20101006160434M.fujita.tomonori@lab.ntt.co.jp>
	 <1286349898.5685.117.camel@haakon2.linux-iscsi.org>
	 <4CAC833F.2010108@kernel.org> <4CACAE56.6090209@vlnb.net>
	 <4CB31CAF.7020808@kernel.org>
Content-Type: text/plain
Date: Mon, 11 Oct 2010 13:26:19 -0700
Message-Id: <1286828779.20358.45.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 16:18 +0200, Tejun Heo wrote:
> Hello,
> 
> On 10/06/2010 07:13 PM, Vladislav Bolkhovitin wrote:
> > Tejun Heo, on 10/06/2010 06:10 PM wrote:
> >> On 10/06/2010 09:24 AM, Nicholas A. Bellinger wrote:
> >>>> I like to hear the opinions of SCSI maintainer and ATA folks.
> >>>
> >>> jejb, jgarzik, tejun and co..?  Any thoughts here..?
> >>
> >> I frankly have no idea whatsoever.  Is there something I can read to
> >> educate myself on the subject?
> > 
> > General information about a SCSI target subsystem you can find in
> > http://scst.sourceforge.net. More internal details about implementation
> > in http://scst.sourceforge.net/scst_pg.html. Features which are
> > implemented in http://scst.sourceforge.net/comparison.html.
> > 
> > Directly on the subject you can find some considerations in
> > http://lkml.org/lkml/2010/10/1/140 (second half of the message).
> > 
> > My opinion is that in ideal the SCSI initiator subsystem should be
> > drivers/scsi/initiator and the target subsystem - drivers/scsi/target
> > with shared code in drivers/scsi/. But in reality such big
> > reorganization is unlikely possible, so it's better to leave SCSI
> > initiator subsystem in drivers/scsi and the target subsystem - in the
> > separate directory in drivers/ (drivers/scst for SCST).
> 
> Thanks for the pointers.  Yeah, it would be pretty interesting to have
> ATA support there too and for ATA I don't really see why anyone would
> mix the initiator and target driver implementations.  They may share
> protocol constants and some utility functions but that will be about
> it, so it will mostly be a completely separate subsystem and I think
> it probably is better to put it somewhere separate too.  I think it
> would be best if we can keep the two subsystems clearly separated.
> They're targeting very different and most likely disjoint audiences
> after all.

Hi Tejun,

So following hch's recent input and my series for unifying the SCSI
control CDB emulation handling of virtual subsystem plugins in TCM v4.0,
the actual struct se_subsystem_api abstraction itself and individual
IBLOCK, FILEIO and RAMDISK subsystem plugins will now be able to
function indepedent of any SCSI layer code.  This will obviously still
require changes to TCM proper and a functioning ATA target mode driver
of course :-), but depending upon the amount of community interest in
this area is something we can start looking at for .38 and .39

Best,

--nab

