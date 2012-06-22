Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293Ab2FVPGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:06:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50924 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762265Ab2FVPGU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 11:06:20 -0400
Message-Id: <4FE4A636020000780008B756@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 16:07:02 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.06.12 at 15:46, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Jan Beulich wrote:
>> One other concern that occurred to me after long having sent
>> the original response: Your proposal aims at a fixed,
>> unmodifiable vMCE interface. How is that going to be forward
>> compatible? I.e. consider you had made that proposal before
>> the SRAO/SRAR changes went in - would the same interface (with
>> the same set of capability bits set/clear) still be suitable?
> 
> Yes, since it's pure s/w emulated interface. At the case when SRAO or SRAR 
> not supported by h/w platform, it's still OK, since under such case 
> hypervisor don't need deliver SRAO or SRAR to guest at all. The emulated vMCE 
> interface just tell the guest that it runs at a virtual platform with those 
> well-defined capabilities.

I probably didn't express well enough what I want you to check:
Consider you had done the current re-design work without
SRAO/SRAR in mind (e.g. a couple of years ago). Would the
end result have been the same? Namely, would the bits you
nominate to be set/clear in MCG_CAP be the same?

>> I think that we minimally need to retain the MCG_CAP register
>> as being of potentially variable content (and hence needing
>> saving/restoring on migration). To support this in a forward
>> compatible manner, we may have to have a way to tell the
>> hypervisor e.g. via command line option which extra MSRs
>> have to be treated read-as-zero/writes-ignored upon guest
>> accesses.
> 
> Seems unnecessary, reason as above.

So going forward you see no possibility of additions to the
interface that might warrant allowing more bits to be set in
MCG_CAP than you define to be set here? That really looks
unrealistic to me.

Jan

