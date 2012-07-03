Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2GCJpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:45:53 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40882
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab2GCJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:45:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2dI98dI1503M1432Izz1202hzz8275bhz2dh668h839hd25he5bhf0ah)
X-WSS-ID: 0M6KWG3-01-79D-02
X-M-MSG: 
Message-ID: <4FF2BF3E.90803@amd.com>
Date: Tue, 3 Jul 2012 11:45:34 +0200
From: Christoph Egger <Christoph.Egger@amd.com>
User-Agent: Mozilla/5.0 (X11; NetBSD amd64; rv:11.0) Gecko/20120404 Thunderbird/11.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Jinsong Liu <jinsong.liu@intel.com>, IanCampbell <Ian.Campbell@citrix.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Donald D Dugger <donald.d.dugger@intel.com>,
        Haitao Shan <haitao.shan@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>, Susie Li <susie.li@intel.com>,
        Tony Luck <tony.luck@intel.com>, Will Auld <will.auld@intel.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KeirFraser <keir@xen.org>
Subject: Re: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com> <4FEB236C020000780008C392@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com> <4FEC3B4A020000780008C673@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com> <4FEC463E020000780008C6A7@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com> <4FEC7FB8020000780008C885@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com> <4FED7C5F.1040908@amd.com> <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com> <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
In-Reply-To: <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/12 09:16, Jan Beulich wrote:

>>>> On 02.07.12 at 19:32, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Thanks AMD's feedback :)
>>
>> This vMCE design foils is basically for Intel MCA, involving many details 
>> specific to Intel.
>> I agree that for x86 Intel and AMD can share logic in many fields. However, 
>> for MCA logic Intel and AMD are quite different, like
>> 1. MSRs interface, e.g. MCG_CAP, MCi_MICS, MCi_CTL2, etc;
>> 2. error injection, AMD provide NMI/single MCE/broadcast MCE, while in our 
>> design only concern broadcast MCE# (and pretend to expose CMCI);
>> 3. MCE handler: currently in xen Intel and AMD mce use different triggle 
>> method and mce handler;
>>
>> Considering the big difference, I suggest we separately provide Intel vMCE 
>> and AMD vMCE (i.e. vmce_intel.c and vmce_amd.c).
> 
> I'm not convinced of the need, and would prefer aiming at a
> shared implementation unless issues arise that make this
> impossible.


I have patches ready that do that. About 80% of mce_intel.c is not
Intel specific. I am just waiting for the feature freeze to end...

Christoph


-- 
---to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Einsteinring 24, 85689 Dornach b. Muenchen
Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

