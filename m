Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1ATDcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:32:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:1247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1ATDcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:32:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,347,1291622400"; 
   d="scan'208";a="649043437"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
CC: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 19 Jan 2011 19:32:05 -0800
Subject: RE: Linux 2.6.38-rc1 doesn't boot
Thread-Topic: Linux 2.6.38-rc1 doesn't boot
Thread-Index: Acu4RuIYFWDQG8F2QQOrWbth7x4UrwAC59fg
Message-ID: <9DA5872FEF993D41B7173F58FCF6BE940570CEFA@orsmsx504.amr.corp.intel.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119073905.GA1652@gentoo.trippels.de>
	 <20110119074902.GA1670@gentoo.trippels.de>
	 <1295424766.1949.879.camel@sli10-conroe> <4D36A759.60704@intel.com>
	 <20110119090904.GA4927@elte.hu> <1295489286.1949.882.camel@sli10-conroe>
In-Reply-To: <1295489286.1949.882.camel@sli10-conroe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0K3WKGL003019

> 
> On Wed, 2011-01-19 at 17:09 +0800, Ingo Molnar wrote:
> > * H. Peter Anvin <h.peter.anvin@intel.com> wrote:
> >
> > > On 01/19/2011 12:12 AM, Shaohua Li wrote:
> > > > On Wed, 2011-01-19 at 15:49 +0800, Markus Trippelsdorf wrote:
> > > >> On 2011.01.19 at 08:39 +0100, Markus Trippelsdorf wrote:
> > > >>> On 2011.01.18 at 15:54 -0800, Linus Torvalds wrote:
> > > >>>>
> > > >>>> And as usual, report any regressions to the lists and the
> appropriate
> > > >>>> authorities.
> > > >>>
> > > >>> Unfortunately 2.6.38-rc1 doesn't even boot on my machine
> (amd64).
> > > >>> This is caused by 86b1e8dd83cbb0f:
> > > >>>     x86: Make relocatable kernel work with new binutils
> > > >>>
> > > >>> Reverting the commit solves the problem.
> > > >>
> > > >> I'm running the latest binutils:
> > > >> GNU ld (Linux/GNU Binutils) 2.21.51.0.5.20110104
> > > > Hmm, reproduce it here with binutils-2.21.51.0.6-20110118
> > > > but not with GNU ld (GNU Binutils for Ubuntu) 2.20.51-
> system.20100908
> > > > I got this in system.map: ffffffff03514880 D jiffies_64, which
> looks
> > > > wrong.
> > > > looks binutils changed something again.
> > > > Have no idea, CC Lu Hongjiu.
> > > >
> > >
> > > Either way... the whole jiffies vs jiffies_64 thing is kind of
> > > ridiculous.  We should be able to do it in a completely
> > > architecture-generic way by either making it a union(!) (with
> "jiffies"
> > > and "jiffies_64" presumably would be #defines, or we do a global
> replace
> > > across the tree), moving the variable declaration itself to a .S
> file
> > > (which would only have data components and therefore would be
> > > arch-generic) or doing something like the attached (untested since
> it is
> > > 1 am here) patch.
> > >
> > > This should let us get rid of the hacks in *all* the architectures,
> not
> > > just x86.
> >
> > Ok - until it's resolved i'll queue up a revert - a known build
> failure is preferred
> > to a boot regression.
> it's not a build failure, without it, my i386 kernel can't boot
> actually.

Kernel build script should check known broken linkers
and refuse to use it.


H.J.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
