Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2LTDDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 22:03:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42679 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2LTDDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 22:03:00 -0500
From: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cpw@sgi.com" <cpw@sgi.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: [PATCH v2] Add the values related to buddy system for filtering
 free pages.
Thread-Topic: [PATCH v2] Add the values related to buddy system for
 filtering free pages.
Thread-Index: AQHN1neGTOb6k8AnJEC/OwmL8lvOwJggS2MAgAAiH4CAAJ8AIA==
Date: Thu, 20 Dec 2012 03:02:56 +0000
Message-ID: <33710E6CAA200E4583255F4FB666C4E20AB2DEA3@G01JPEXMBYT03>
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
 <20121219161856.e6aa984f.akpm@linux-foundation.org>
 <20121220112103.d698c09a9d1f27a253a63d37@mxc.nes.nec.co.jp>
In-Reply-To: <20121220112103.d698c09a9d1f27a253a63d37@mxc.nes.nec.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.124.101.123]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: kexec-bounces@lists.infradead.org
> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of Atsushi Kumagai
> Sent: Thursday, December 20, 2012 11:21 AM

> On Wed, 19 Dec 2012 16:18:56 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 10 Dec 2012 10:39:13 +0900
> > Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp> wrote:
> >

> >
> > We might change the PageBuddy() implementation at any time, and
> > makedumpfile will break.  Or in this case, become less efficient.
> >
> > Is there any way in which we can move some of this logic into the
> > kernel?  In this case, add some kernel code which uses PageBuddy() on
> > behalf of makedumpfile, rather than replicating the PageBuddy() logic
> > in userspace?
> 
> In last month, Cliff Wickman proposed such idea:
> 
>   [PATCH v2] makedumpfile: request the kernel do page scans
>   http://lists.infradead.org/pipermail/kexec/2012-November/007318.html
> 
>   [PATCH] scan page tables for makedumpfile, 3.0.13 kernel
>   http://lists.infradead.org/pipermail/kexec/2012-November/007319.html
> 
> In his idea, the kernel does page scans to distinguish unnecessary pages
> (free pages and others) and returns the list of PFN's which should be
> excluded for makedumpfile.
> As a result, makedumpfile doesn't need to consider internal kernel
> behavior.
> 
> I think it's a good idea from the viewpoint of maintainability and
> performance.

I also think wide part of his code can be reused in this work. But the bad
performance is caused by a lot of ioremap, not a lot of copying. See my
profiling result I posted some days ago. Two issues, ioremap one and filtering
maintainability, should be considered separately. Even on ioremap issue,
there is secondary one to consider in memory consumption on the 2nd kernel.

Also, I have one question. Can we always think of 1st and 2nd kernels are same?
If I understand correctly, kexec/kdump can use the 2nd kernel different
from the 1st's. So, differnet kernels need to do the same thing as makedumpfile
does. If assuming two are same, problem is mush simplified.

Thanks.
HATAYAMA, Daisuke

