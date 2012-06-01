Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab2FANv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:51:28 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:43992 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759876Ab2FANv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:51:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0.D_GccVM1kGkvGOE2DghUBir5GFIeJZznMOoVazbld51Rx
 8r3ySHGOxsm8pp4d29msTAHQkdDFESVN4AFApSkhqxTFsP4_lmNTNYHDhzn3
 Rwj75pVFrFUIv_prlOTSXMTabf16KQTygbRBAFQH6UkIwfSd.fEFkkwgSl9s
 Oy9TLnezi9LwlEhqnGHvEgrIpmGNo1OCsRFptEbFkMNuNYIiUyOfS2V_Prjk
 HEDUP8elvi9sNmRkeDbb8xKzHoFUFw4I.Z1jDomtXSTX15cN4vg1Chkzru3N
 lsLU1NN4.WgRkBmTHdE6oJ_IsWI7GVzj7smbv1tRLW_49fFNR_oTpS1DnEUG
 Izq9LldtWD85_XPEoXqCLwHoSQBtKS1JGQCPc6c2a5KBhJxQsRsM9qDMKUb_
 3
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 1 Jun 2012 08:51:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: david@lang.hm
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
In-Reply-To: <alpine.DEB.2.02.1205311744280.17976@asgard.lang.hm>
Message-ID: <alpine.DEB.2.00.1206010850430.6302@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org> <alpine.DEB.2.00.1205301441350.31768@router.home> <CAHGf_=ooVunBpSdBRCnO1uOoswqxcSy7Xf8xVcgEUGA2fXdcTA@mail.gmail.com> <20120530201042.GY27374@one.firstfloor.org>
 <CAHGf_=r_ZMKNx+VriO6822otF=U_huj7uxoc5GM-2DEVryKxNQ@mail.gmail.com> <alpine.DEB.2.02.1205311744280.17976@asgard.lang.hm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, david@lang.hm wrote:

> On Wed, 30 May 2012, KOSAKI Motohiro wrote:
>
> > On Wed, May 30, 2012 at 4:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > > Yes, that's right direction, I think. Currently, shmem_set_policy()
> > > > can't handle
> > > > nonlinear mapping.
> > >
> > > I've been mulling for some time to just remove non linear mappings.
> > > AFAIK they were only useful on 32bit and are obsolete and could be
> > > emulated with VMAs instead.
> >
> > I agree. It is only userful on 32bit and current enterprise users don't use
> > 32bit anymore. So, I don't think emulated by vmas cause user visible issue.
>
> I wish this was true, there are a lot of systems out there still running 32
> bit linux, even on 64 bit capible hardware. This is especially true in
> enterprises where they have either homegrown or proprietary software that
> isn't 64 bit clean.

32 bit binaries (and entire distros) run fine under 64 bit kernels.

