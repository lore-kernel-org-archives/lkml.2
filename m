Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0LCTf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 14:35:28 -0500
Received: from mxs.selfmail.ru ([77.221.143.26]:37991 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752582Ab0LCTf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 14:35:27 -0500
X-ACL-SPF: 
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <alpine.DEB.2.00.1012021720170.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
	 <1291236234.22027.0.camel@mobile>
	 <alpine.DEB.2.00.1012021720170.14723@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Fri, 03 Dec 2010 22:35:00 +0300
Message-ID: <1291404900.5298.15.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 17:21 +0000, Stefano Stabellini wrote:
> On Wed, 1 Dec 2010, Vasiliy G Tolstov wrote:
> > On Wed, 2010-12-01 at 18:25 +0000, Stefano Stabellini wrote:
> > > Hi all,
> > > this small patch series achieves two goals:
> > > 
> > > - make PV consoles work for PV on HVM guests;
> > > 
> > > - implement support for multiple PV consoles for PV and PV on HVM guests.
> > > 
> > > Stefano Stabellini (2):
> > >       hvc_xen: support PV on HVM consoles
> > >       hvc_xen: implement multiconsole support
> > > 
> > >  drivers/char/hvc_xen.c             |  479 ++++++++++++++++++++++++++++++++----
> > >  include/xen/interface/hvm/params.h |    6 +-
> > >  2 files changed, 441 insertions(+), 44 deletions(-)
> > > 
> > > A branch with these patches on 2.6.37-rc4 is available here:
> > > 
> > > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-pvconsole
> > > 
> > > Cheers,
> > 
> > Does it possible to apply only this 2 patches on stable-2.6.32.x and get
> > working serial consoles?
> > 
> 
> I backported the two patches to stable-2.6.32 and created a new branch
> that is stable-2.6.32.x + support PV on HVM consoles + implement
> multiconsole support:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git stable-2.6.32-pvconsole
> 
> I still haven't tested it with xend though.

Kernel crushed =(. Use config file from 64 bit fully worked
configuration, what does it mean? How can i find reason for this crush?

(XEN) d330:v0: unhandled page fault (ec=0000)
(XEN) Pagetable walk from 0000000000000000:
(XEN)  L4[0x000] = 0000000000000000 ffffffffffffffff
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 330 (vcpu#0) crashed on cpu#12:
(XEN) ----[ Xen-4.0.0_21091_06-0.2.1  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    12
(XEN) RIP:    e033:[<ffffffff810bd17e>]
(XEN) RFLAGS: 0000000000000246   EM: 1   CONTEXT: pv guest
(XEN) rax: 0000000000000000   rbx: 0000000000008000   rcx:
fffffffffffffffb
(XEN) rdx: ffffffff819d7000   rsi: 00000000000080d0   rdi:
ffffffff81536be0
(XEN) rbp: ffffffff81533d78   rsp: ffffffff81533cf0   r8:
0000000000000000
(XEN) r9:  0000000000000020   r10: 0000000000000000   r11:
0000000000000000
(XEN) r12: 0000000000000000   r13: ffffffff815d95e1   r14:
ffffffff815d9500
(XEN) r15: ffffffff8130f049   cr0: 000000008005003b   cr4:
00000000000026f0
(XEN) cr3: 0000001018ffe000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
(XEN) Guest stack trace from rsp=ffffffff81533cf0:
(XEN)    fffffffffffffffb 0000000000000000 0000000000000000
ffffffff810bd17e
(XEN)    000000010000e030 0000000000010046 ffffffff81533d38
000000000000e02b
(XEN)    ffffffff810bd165 ffffffff81533d78 ffffffff81536be0
0000000000000000
(XEN)    0000000000000000 0000000000000000 ffffffff815d95e1
ffffffff815d9500
(XEN)    ffffffff815d95d5 ffffffff81533d98 ffffffff8130f049
ffffffff0000000f
(XEN)    ffffffff8156a050 ffffffff81533da8 ffffffff8130f121
ffffffff81533de8
(XEN)    ffffffff8104443e ffffffff815d95c8 ffffffff815d95e1
0000000000000000
(XEN)    ffffffff815d95e1 ffffffff815d95e1 ffffffff815d95d5
ffffffff81533df8
(XEN)    ffffffff81026075 ffffffff81533e18 ffffffff815b5ebb
ffffffff816116c0
(XEN)    ffffffff815d95d5 ffffffff81533e48 ffffffff815a6738
000000000000000b
(XEN)    ffffffff815d95e5 0000000000000000 00000000fffffffe
ffffffff81533ea8
(XEN)    ffffffff810549dc 0000000081533d00 0000000000000000
ffffffff814a9d9f
(XEN)    ffffffff815a66db ffffffff81533ea8 ffffffff815d8da0
0000000000000000
(XEN)    ffffffff81533f70 ffffffffffffffff 0000000000000000
ffffffff81533eb8
(XEN)    ffffffff815a67c7 ffffffff81533ec8 ffffffff815a67fa
ffffffff81533f58
(XEN)    ffffffff815aa558 0000000000000000 0000000000000000
ffffffffffffffff
(XEN)    0000000000000000 ffffffff81533f58 ffffffff813d9ee2
ffffffff00000010
(XEN)    ffffffff81533f68 ffffffff81533f28 ffffffff8105fa4b
ffffffffffffffff
(XEN)    ffffffff815d8da0 0000000000000000 0000000000000000
ffffffffffffffff
(XEN)    0000000000000000 ffffffff81533f98 ffffffff815a68a3
ffffffff81533f98
(XEN) cpupool_rm_domain(dom=330,pool=0) n_dom 304
(XEN) mm.c:2562:d0 Unknown domain '330'
(XEN) mm.c:2562:d0 Unknown domain '330'
(XEN) mm.c:2562:d0 Unknown domain '330'
(XEN) mm.c:2562:d0 Unknown domain '330'




