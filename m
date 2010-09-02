Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0IBUWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:22:49 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:39307 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756801Ab0IBUWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:22:48 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: xFpAbooVM1kmAosJB5Uy6s5v9Ba1vUg7agmbOhAlUs.QjM7
 HHzMWUDVmuN3IYH_NxGDVBJHUKb7t9RQZVVMXQcece7rtMFjPajxG3FT1f1T
 muyTtEOpkdL0FG4hJhgh1kHO2RIOhKqjywynL9LE0EmBE4mAw5kVQ5RXcrpQ
 7iHT0W_yaRWkFARW6cnEXKIuYZdc0hrdu1IEbzpg.TJL20jQlUOTCkgWjxNJ
 s2MN4yNiccRz9Av7iDGdkbB56XBafXfF1jTP.BWJtOB2OsDwZMtGKzKSEN6x
 v3NBFeXv0bPwSMcfi8yklepDridBs1oUHUJW8fyFaQBC.b3olQ40qBArViwu
 0YExmu_MA75h8K86vWnHWEyi479zqHwb1Uuop21.KU.kTCLWriRT97CKHYGt
 wOyCxu0dNH6mJ_Dttutk7Ls6aob2q.Y8kC9rbhAbwfIqdigDeMmugPZHm8CO
 ACMM5TKah
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between
	different SCSI targets (SCST, STGT, IET, LIO) updated
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Weiss <cweiss@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Ross Walker <rswwalker@gmail.com>
In-Reply-To: <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
References: <4C7FFB85.7000006@vlnb.net>
	 <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 02 Sep 2010 13:12:11 -0700
Message-Id: <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 15:00 -0500, Chris Weiss wrote:
> On Thu, Sep 2, 2010 at 2:31 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > Hello,
> >
> > I updated the Linux SCSI targets comparison page
> > http://scst.sourceforge.net/comparison.html, which compares features of
> > the existing Linux SCSI target subsystems. The comparison includes SCST,
> > STGT, IET and LIO. I added IET there, because it is the most used Linux
> > iSCSI target at the moment.
> .
> .
> >
> > If you see I'm wrong somewhere or forgot something, you are welcome to
> > correct me and I will fix that.
> >
> > Vlad
> >
> 
> as a user following the potential inclusion of a kernel-space target,
> iscsi specifically, I would be very interested in seeing what other
> pluses the other frameworks have over scst, because if this chart is
> accurate, all the other targets have quite a ways to go to catch up.
> 

Actually sorry, anyone who has spent more than 30 minutes looking at the
TCM v4 code that has already been posted to linux-scsi on monday knows
this list just more handwaving.  I suggest you start doing the same
(actually discussion specific source file + line refrences) unless you
actually want to trust this hopelessly out-of-date list on blind
princaple.

> To me, lacking correct reserve and task management means "not ready
> for public consumption".  Making any kernel change that does not have
> RESERVE/RELEASE and full TM command support is only going to make
> Linux look buggy and amateur-ish in the storage world.

First, understand that Vlad has been asked to produce a problem use case
for his CRH=1 (Compatibility Reservation Handling) concerns using the
SPC-3 RESERVE/RELEASE methods with the TCM v4 code.  He has been never
been able to produce a use case, ever.  Also, just for reference, does
SCST's SPC-3 persisent reservation handling actually properly support
CRH=1 emulation from spc4r17..?  Last time I checked, it most certainly
did *not*.

Second, in terms of TM emulation / passthrough support in the TCM v4
code, we follow what is implemented in drivers/scsi ML and LLDs,
primarly to properly for Linux SCSI Initiators.  I honestly don't have
alot of interesting currently in implementing all of the ancient TM
emulation that none of the mainline SCSI LLDs in Linux implement today,
or plan to do the future.  As for specific TM concerns, I am happy to
address then on a case by case basis with the appropiate use case.

Best,

--nab

