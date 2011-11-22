Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1KVTUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:20:19 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:23071 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752871Ab1KVTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:20:17 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UsUnQkcVM1k1C18xz4U9HGiSKM5S9K87NBv0TopTIqiZQym
 tHdaKiJgPQfOHiJ.EysKiRS5he8hdhdsqQ.yrMbzuEVy_VV1lrACot6mWhyX
 A913zo0qpTJT.yzYvuSJSkucWEv19ay2VNjuEvoBzPNGRP7IycKSVGQMRHfs
 9zeI1_KhaHgdmB.OzPQU.ZNCLGq_PCLlYeFpS1GbIQdFGCUBgPmxSGfGKEh8
 du5i5R0xCy8Dcw3aXph_PE4fcepzDPqhQ1Ghr35is91ikehqEfvCVupgRFK1
 hZuGUe4ZA9ceIAHO9wmGLKhep1OzpVHoTv0KC1TPkJtaHHRODwFNN4Jp3PkC
 vMOFV_N1Hs6JtsyVvz5CRlShzTB_rhrd9kAtWz.K.zIeljg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 13:20:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: slub: Lockout validation scans during freeing of object
In-Reply-To: <20111122185540.GA1627@x4.trippels.de>
Message-ID: <alpine.DEB.2.00.1111221319070.30368@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home> <alpine.DEB.2.00.1111221040300.28197@router.home> <alpine.DEB.2.00.1111221052130.28197@router.home> <1321982484.18002.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111221139240.28197@router.home>
 <20111122185540.GA1627@x4.trippels.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Markus Trippelsdorf wrote:

> On 2011.11.22 at 11:40 -0600, Christoph Lameter wrote:
> > On Tue, 22 Nov 2011, Eric Dumazet wrote:
> >
> > > This seems better, but I still have some warnings :
> >
> > Trying to reproduce with a kernel configured to do preempt. This is
> > actually quite interesting since its always off by 1.
>
> BTW there are some obvious overflows in the "slabinfo -l" output on my machine:

Could you get me the value of the "slabs" field for the slabs showing the
wierd values. I.e. do

cat /sys/kernel/slab/signal_cache/slabs

> signal_cache               268     920   360.4K 18446744073709551614/7/24   17 2  31  68 A
