Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2FNVwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:52:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:57177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab2FNVwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="153377918"
From: "Brown, Len" <len.brown@intel.com>
To: Dave Airlie <airlied@gmail.com>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
CC: "intergalactic.anonymous@gmail.com" 
	<intergalactic.anonymous@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: RE: [3.4 regression] [bisected] DisplayPort fails to come on
Thread-Topic: [3.4 regression] [bisected] DisplayPort fails to come on
Thread-Index: AQHNSjFlD2LrnKS06kCvJWvBH8Oae5b6TSYAgAAMPkA=
Date: Thu, 14 Jun 2012 21:52:48 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C9481FCA16A8@FMSMSX108.amr.corp.intel.com>
References: <4FD9E69A.4090708@cwi.nl>
 <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com>
In-Reply-To: <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wouter,
Please test the latest patch here:

https://bugzilla.kernel.org/show_bug.cgi?id=43168

thanks,
Len Brown, Intel Open Source Technology Center


> > When I cold boot 3.4 on my laptop the second monitor attached to the
> > displayport stays blank. It works fine with 3.3.8 and earlier.
> >
> > I get two error messages in dmesg:
> >
> > kernel: video: probe of LNXVIDEO:00 failed with error -5
> >
> > kernel: [drm:intel_dp_complete_link_train] *ERROR* failed to train DP,
> > aborting
> >
> > When I warm boot 3.4 after running kernel 3.3.8 first, only the first
> > message appears and the display works fine.
> >
> > A bisection based on the occurrence of the first error message
> > resulted in
> >
> > Author: Igor Murzov <intergalactic.anonymous@gmail.com>  2012-03-30
> > 18:32:08
> > Committer: Len Brown <len.brown@intel.com>  2012-03-30 20:44:05
> > Parent: c16fa4f2ad19908a47c63d8fa436a1178438c7e7 (Linux 3.3)
> > Branches: linux-3.4.y, remotes/origin/linux-3.4.y,
> > remotes/origin/master
> > Follows: v3.3
> > Precedes: v3.4-rc1
> >
> >    ACPI video: Harden video bus adding.
> >
> >    It is always better to check return values, so add some new checks
> > and
> >    correct existing ones.
> >
> >    v2: Be consistent and don't mix errors from -E* and AE_* namespaces.
> >
> >    Signed-off-by: Igor Murzov <e-mail@date.by>
> >    Signed-off-by: Len Brown <len.brown@intel.com>
> >
> >
> > The laptop is a Dell System XPS L702X/0XN71K, BIOS A17 02/22/2012. It
> > has two graphics card in Optimus configuration:
> > 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
> > Core Processor Family Integrated Graphics Controller (rev 09)
> > 01:00.0 VGA compatible controller: NVIDIA Corporation Device 124d (rev
> > a1)
> >
> > I only use the Intel card (which drives the DP port if I am not
> > mistaken)
> >
> > I hope this is helpful. Please let me know what I can do next to track
> > this problem down.
> >
> > With kind regards,
> >
> > Wouter Koolen
