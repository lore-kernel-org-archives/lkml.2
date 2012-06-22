Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431Ab2FVPyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:54:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36339 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2FVPyL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 11:54:11 -0400
Message-Id: <4FE4B16C020000780008B7A6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 16:54:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>, "Tony Luck" <tony.luck@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Will Auld" <will.auld@intel.com>,
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
 <3908561D78D1C84285E8C5FCA982C28F1932337D@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1932337D@ORSMSX104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.06.12 at 17:29, "Luck, Tony" <tony.luck@intel.com> wrote:
>>  1). still use 1 bank and simply ignore this issue. I mean, even if guest 
>> runs at bank0 quirks platform, when hypervisor inject vMCE# to guest, guest 
>> skip bank0, then guest MCE logic would think it detect a spurious mce, then 
>> kill itself. Considering bank0 quirks is only for old cpus, this is 
>> acceptable;
>> 2). use 32 banks
>> 
>> In fact, a third option is, use 1 bank, but hypervisor kill guest when it 
>> detect bank0 quirks. This would be same effect as option 1, so I prefer let 
>> guest kill itself.
> 
> Don't you control what CPUID is shown to the guest? Under what circumstances
> would you tell the guest that it is running on an AMD-K7 or an Intel family
> 6 with model < 0x1A?   Surely for migration reasons you need to present the
> same virtualized family/model all the time ... so just don't use ones that
> cause problems.

I don't think family/model/stepping are frequently faked, it's
normally just the various feature flags that get normalized to
the smallest common set.

> If that isn't an option - then say there are 2 banks and have Xen ignore bank
> 0 (make MC0_STATUS always appear to contain 0) and put all the errors into
> bank1.  If you tell the guest there are 32 banks it will read all of them.
> Which means a lot of pointless exits to the hypervisor.

Indeed, emulating too many banks can have its own downsides.
Yet I don't think we're really concerned about performance when
handling machine checks. But having more than one usable bank
must have advantages, else hardware wouldn't implement things
that way.

Jan

