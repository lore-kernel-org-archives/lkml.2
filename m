Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2EaR17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:27:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:55479 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab2EaR15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106367738"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Thread-Topic: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Thread-Index: AQHNP0gP2qSMzi1PTzSzWPGw5NRHt5bkIgcw
Date: Thu, 31 May 2012 17:27:53 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FFB11@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
 <20120531161139.GA13939@phenom.dumpdata.com>
In-Reply-To: <20120531161139.GA13939@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FFB11SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB11SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Konrad Rzeszutek Wilk wrote:
> On Thu, May 31, 2012 at 12:57:44PM +0000, Liu, Jinsong wrote:
>>> From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00
>>> 2001=20
>> From: root <root@ljsromley.bj.intel.com>
>=20
> Also your git author is busted. I fixed it up for you but
> you might want to run 'git config --user.name' and such

Ah, I forgot it. Thanks for fix it.

>=20
>> Date: Fri, 1 Jun 2012 03:12:51 +0800
>> Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
>=20
> What about the cvt_gate_to_trap? Does that need something similar
> to "xen/mce: Register native mce handler as vMCE bounce back point"
> ?

That's vMCE injection logic.
anyway, I will present new round of patch according to Boris and your comme=
nds, as following
[Patch 1/3] xen-mce-Add-mcelog-support-for-Xen-platform.patch
[Patch 2/3] X86-MCE-AMD-Adjust-initcall-sequence-for-xen.patch
[Patch 3/3] Register-native-mce-handler-as-vMCE-bounce-back-poin.patch

Patch 1/3 and 2/3 are for mcelog
Patch 3/3 are for vMCE injection

>=20
> I stuck all these patches on devel/mce.v2 on
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git

Hmm, we discussed base-tree problem before, and decided to use linus latest=
 tree.
I pull this morning and rebase my patches based on
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
c/s a01ee165a132fadb57659d26246e340d6ac53265


Thanks,
Jinsong=

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB11SHSMSX101ccrcorpi_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 31 May 2012 17:27:53 GMT";
	modification-date="Thu, 31 May 2012 17:27:53 GMT"

Received: from rrsmsx602.amr.corp.intel.com (10.31.0.33) by
 SHSMSX151.ccr.corp.intel.com (10.239.6.50) with Microsoft SMTP Server (TLS)
 id 14.1.355.2; Fri, 6 Apr 2012 23:12:54 +0800
Received: from fmsmga002.fm.intel.com (10.253.24.26) by
 rrsmsx602-1.rr.intel.com (10.31.0.33) with Microsoft SMTP Server id
 8.2.255.0; Fri, 6 Apr 2012 09:12:52 -0600
Received: from fmsmga102.fm.intel.com ([10.1.193.69])  by
 fmsmga002-1.fm.intel.com with ESMTP; 06 Apr 2012 08:12:51 -0700
Received: from rcsinet15.oracle.com ([148.87.113.117])  by mga11.intel.com
 with ESMTP; 06 Apr 2012 08:12:51 -0700
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id
 q36FCnit012218	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256
 verify=OK)	for <jinsong.liu@intel.com>; Fri, 6 Apr 2012 15:12:50 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])	by
 acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q36FCnNT012571
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)	for
 <jinsong.liu@intel.com>; Fri, 6 Apr 2012 15:12:49 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])	by
 acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q36FCn2I002395
	for <jinsong.liu@intel.com>; Fri, 6 Apr 2012 10:12:49 -0500
Received: from phenom.dumpdata.com (/209.6.85.33)	by default (Oracle Beehive
 Gateway v4.0)	with ESMTP ; Fri, 06 Apr 2012 08:12:48 -0700
Received: by phenom.dumpdata.com (Postfix, from userid 1000)	id 8A42C4031D;
 Fri,  6 Apr 2012 11:08:10 -0400 (EDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Subject: Re: Xen ras rebase base tree
Thread-Topic: Xen ras rebase base tree
Thread-Index: AQHNFAcUz2Gw25lhT/Ka9W6Fnpe+PQ==
Date: Fri, 6 Apr 2012 15:08:10 +0000
Message-ID: <20120406150810.GA19124@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335125D6D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335125D6D@SHSMSX101.ccr.corp.intel.com>
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: rrsmsx602.amr.corp.intel.com
X-MS-Has-Attach: 
X-Message-Flag: Follow up
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.75,381,1330934400";
    d="scan'208";a="1246752134"
x-ironport-anti-spam-filtered: true
x-ironport-anti-spam-result: Al4CAD4Gf0+UV3F1nGdsb2JhbABFuR0iAQEBAQEICwkJFCeCCQEBAgIBOk8LGC4UGDGIHAUEumWPbWMElWsBkzk
user-agent: Mutt/1.5.21 (2010-09-15)
x-ct-refid: str=0001.0A090207.4F7F07F2.00C0,ss=1,re=0.000,fgs=0
x-source-ip: acsinet22.oracle.com [141.146.126.238]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB9E0E717F664E4C85B9C0F9D8737C88@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

On Fri, Apr 06, 2012 at 07:13:43AM +0000, Liu, Jinsong wrote:
> Konrad,
>=20
> I'm rebasing Xen mcelog and cpu online/offline logic now.
> I'm not quite sure which tree is proper as base tree, has your Xen PM pat=
ches all in kernel tree now? if yes, maybe we can directly rebased on lates=
t kernel tree, your opinion?

Use the linus tree. The latest has the xen pm patches.

>=20
> and, if we rebased on your pvops
> 1. what's the git address (git://git.kernel.org/pub/scm/linux/kernel/git/=
konrad/xen.git ?)
> 2. which branch (linux-next ?)
> (considering your PM patches (which cpu hotplug need reuse some logic) ha=
s been in kernel ?)
>=20
> Thanks,
> Jinsong

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB11SHSMSX101ccrcorpi_--
