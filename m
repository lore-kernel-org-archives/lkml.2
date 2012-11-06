Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KFL50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:57:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:22452 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2KFL5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:57:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="214047988"
Date: Tue, 6 Nov 2012 19:57:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [digsig:dmi 20/35] WARNING:
 security/integrity/built-in.o(.text+0x1d8): Section mismatch in reference
 from the function integrity_inode_free() to the variable
 .init.data:ima_use_tcb
Message-ID: <20121106115716.GA21889@localhost>
References: <50913fa5.uJnC6BQdkN/Xw1h0%fengguang.wu@intel.com>
 <CALLzPKZdh9a0nT52GOZEO7dgxtLqU_VwD27Qs_gBe-bSk=J87g@mail.gmail.com>
 <20121106114108.GB19965@localhost>
 <CALLzPKb-9uHdbqUujbcQ2z38Lv5sqBKtmYmjYDdVhgVs4WF6cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKb-9uHdbqUujbcQ2z38Lv5sqBKtmYmjYDdVhgVs4WF6cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps we should CC more people..

On Tue, Nov 06, 2012 at 01:47:18PM +0200, Kasatkin, Dmitry wrote:
> On Tue, Nov 6, 2012 at 1:41 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Tue, Nov 06, 2012 at 01:16:16PM +0200, Kasatkin, Dmitry wrote:
> >> Hi,
> >>
> >> I do not see that integrity_inode_free() uses ima_use_tcb.
> >>
> >> I think it is false positive.
> >
> > Interestingly, when trying to reproduce the problem, I got this
> > slightly different message:

Now after make clean, I get both the warnings on ima_use_tcb and
chosen_lsm.

> > WARNING: security/built-in.o(.text+0x2b68c): Section mismatch in reference from the function integrity_inode_free() to the variable .init.d
> > ata:chosen_lsm
> > The function integrity_inode_free() references
> > the variable __initdata chosen_lsm.
> > This is often because integrity_inode_free lacks a __initdata
> > annotation or the annotation of chosen_lsm is wrong.
> >
> 
> Hello,
> 
> chosen_lsm has nothing to do with integrity subsystem, though
> integrity_inode_free() is called from security_inode_free(),
> which is part of security subsystem files which uses chosen_lsm...
> 
> That is very strange.
> 
> - Dmitry
> 
> 
> > Thanks,
> > Fengguang
> >
> >> On Wed, Oct 31, 2012 at 5:11 PM, kbuild test robot
> >> <fengguang.wu@intel.com> wrote:
> >> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig.git dmi
> >> > head:   2309bb884f94d84ecb1a6a176d3e8199de7d6dad
> >> > commit: 13ba29dcf6f0021a14a04f6f3a4560a399c02b34 [20/35] integrity: create and inititialize a keyring with builtin public key
> >> > config: make ARCH=xtensa allyesconfig
> >> >
> >> > All warnings:
> >> >
> >> > WARNING: security/integrity/built-in.o(.text+0x1d8): Section mismatch in reference from the function integrity_inode_free() to the variable .init.data:ima_use_tcb
> >> > The function integrity_inode_free() references
> >> > the variable __initdata ima_use_tcb.
> >> > This is often because integrity_inode_free lacks a __initdata
> >> > annotation or the annotation of ima_use_tcb is wrong.
> >> >
> >> > ---
> >> > 0-DAY kernel build testing backend         Open Source Technology Center
> >> > Fengguang Wu, Yuanhan Liu                              Intel Corporation
