Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2GWGzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:55:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:57071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab2GWGzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:55:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="196577492"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Daniel J Blueman <daniel@quora.org>,
        Intel Linux Wireless <ilw@linux.intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: 3.5.0 iwlagn AP crash...
Thread-Topic: 3.5.0 iwlagn AP crash...
Thread-Index: AQHNZ+qOQyja1sAo20WrvL/lQkU2oJc1A86AgAFsOlA=
Date: Mon, 23 Jul 2012 06:54:29 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE619593035@IRSMSX102.ger.corp.intel.com>
References: <CAMVG2su3DfOTRHDr7oFPLM5LVOBEXtChPEy4LL_2QS-VT9vBgg@mail.gmail.com>
 <CAMVG2suiMXojoptfNNJEZWhiBfgVcU99BTvG6jqdKAFGBf65MA@mail.gmail.com>
In-Reply-To: <CAMVG2suiMXojoptfNNJEZWhiBfgVcU99BTvG6jqdKAFGBf65MA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > When running my Centrino Wireless-N 130 BGN (rev 0xb0) card in nl80211
> > AP mode with hostapd on linux 3.5.0, I immediately hit this fatal
> > pagefault [1].
> >
> > I can cook a debug kernel, reproduce, disassemble the code and do some
> > quick analysis, if that helps get the ball rolling?

> > BUG: unable to handle kernel NULL pointer dereference at      (null)
> > IP: [<ffffffffa02e869d>] ieee80211_ave_rssi+0xd/0x50 [mac80211]
> 
> From my debug kernel, sdata is clearly NULL:
> 
> (gdb) list *0xffffffff815b74f8
> 0xffffffff815b74f8 is in ieee80211_ave_rssi (net/mac80211/util.c:1801).
> 1796	int ieee80211_ave_rssi(struct ieee80211_vif *vif)
> 1797	{
> 1798		struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);

I'll look into it, thanks.

johannes
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer, Christian Lamprechter
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

