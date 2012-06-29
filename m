Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2F2J7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:59:10 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:7636 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab2F2J7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:59:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd25he5bhf0ah)
X-WSS-ID: 0M6DIED-01-0N6-02
X-M-MSG: 
Message-ID: <4FED7C5F.1040908@amd.com>
Date: Fri, 29 Jun 2012 11:58:55 +0200
From: Christoph Egger <Christoph.Egger@amd.com>
User-Agent: Mozilla/5.0 (X11; NetBSD amd64; rv:11.0) Gecko/20120404 Thunderbird/11.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Jan Beulich <JBeulich@suse.com>, "Auld, Will" <will.auld@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "Luck, Tony" <tony.luck@intel.com>, Keir Fraser <keir@xen.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Li, Susie" <susie.li@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com> <4FEB236C020000780008C392@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com> <4FEC3B4A020000780008C673@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com> <4FEC463E020000780008C6A7@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com> <4FEC7FB8020000780008C885@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Feedback from the AMD side:

slide 2:
- PV guests are supposed to install a MCE trap handler
  which reads the MSR values from struct mcinfo_bank.
  Hence it is unclear where the #GP should come from.
  Same for HVM guests which have a PV MCE "driver"
  (those are very rare in reality).

slide 3:
- unclear what "Weird per-domain MSRs" means
- unclear what "Unnatural MCE injection semantics" means

slide 4:
- typo: interace -> interface :-)
- enable UCR-related capabilities, but only on Intel machines
- Filter non-SRAO/SRAR banks:
  Rename it to "Let guest see northbridge bank only to the guest"

slide 7:
- ignore/disable CMCI and CTL2 on AMD

slide 8:
- Filter non-SRAO/SRAR banks:
  Rename it to "Let guest see northbridge bank only to the guest"
- Question: Should we allow the guest to inject errors? Does it make
  sense?
- always disable MCi_CTL2 on AMD

slide 9:
- Model specific issue: Also affects AMD as some models have
  l3 cache and some do not.
  E.g. it does not make sense to report l3 cache errors to guests


-- 
---to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Einsteinring 24, 85689 Dornach b. Muenchen
Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

