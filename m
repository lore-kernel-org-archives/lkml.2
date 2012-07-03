Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab2GCHPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:15:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48118 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2GCHPv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 3 Jul 2012 03:15:51 -0400
Message-Id: <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Jul 2012 08:16:44 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Christoph Egger" <Christoph.Egger@amd.com>,
        "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "IanCampbell" <Ian.Campbell@citrix.com>, "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "KeirFraser" <keir@xen.org>
Subject: RE: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
 <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com>
 <4FEC7FB8020000780008C885@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
 <4FED7C5F.1040908@amd.com>
 <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.07.12 at 19:32, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Thanks AMD's feedback :)
> 
> This vMCE design foils is basically for Intel MCA, involving many details 
> specific to Intel.
> I agree that for x86 Intel and AMD can share logic in many fields. However, 
> for MCA logic Intel and AMD are quite different, like
> 1. MSRs interface, e.g. MCG_CAP, MCi_MICS, MCi_CTL2, etc;
> 2. error injection, AMD provide NMI/single MCE/broadcast MCE, while in our 
> design only concern broadcast MCE# (and pretend to expose CMCI);
> 3. MCE handler: currently in xen Intel and AMD mce use different triggle 
> method and mce handler;
> 
> Considering the big difference, I suggest we separately provide Intel vMCE 
> and AMD vMCE (i.e. vmce_intel.c and vmce_amd.c).

I'm not convinced of the need, and would prefer aiming at a
shared implementation unless issues arise that make this
impossible.

Jan

