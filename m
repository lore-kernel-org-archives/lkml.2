Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2F1JkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:40:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:60376 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab2F1JkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:40:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159152952"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "Auld, Will" <will.auld@intel.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [xen vMCE RFC V0.2] xen vMCE design
Thread-Topic: [xen vMCE RFC V0.2] xen vMCE design
Thread-Index: AQHNVQ2m1l9vq4iTRyWE8p2SJy8j95cPc0zw
Date: Thu, 28 Jun 2012 09:40:08 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
In-Reply-To: <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> On 28.06.12 at 10:54, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Jan Beulich wrote:
>>> The 2-bank approach also needs to be brought in line with the
>>> current host derived value in MCG_CAP, especially if the code to
>>> implement this new model doesn't make it into 4.2 (which would
>>> generally save a larger value).
>> 
>> Let me repeat in my word to avoid misunderstanding about your
>> concern: 
>> Your concern rooted from the history patch (c/s 24887, as attached)
>> which used to solve vMCE migration issue caused from bank number. I
>> guess the patch was not in xen4.1.x but would be in xen 4.2 release
>> recently (right? and when will xen 4.2 release?)
> 
> 4.2 is in feature freeze right now, preparing for the release.
> 
>> Per my understanding, you want us to make sure our new vMCE model
>> compatible w/ olde vMCE. For example if our patch in xen 4.3
>> release, you want to make sure a guest migrate from xen 4.2 to 4.3
>> would not broken. Is this your concern?
> 
> Yes. If we can't get the save/restore records adjusted in time
> for 4.2, compatibility with 4.2 would be a requirement. If we
> manage to get the necessary adjustments done in time, and if
> they're not too intrusive (i.e. would be acceptable at this late
> stage of the development cycle), then the concern could be
> dropped from an upstream perspective due to the lack of
> support in 4.1 (and hence no backward compatibility issues).
> BUT this isn't as simple from a product usage point of view: As
> the save/restore code currently in -unstable was coded up to
> address a problem observed by SLE11 SP2 users, we already
> backported those patches. So compatibility will be a requirement
> in any case.
> 
> Jan

A basic point of new vMCE is, it get rid of old vMCE, start setting up a new model from the very beginning. From coding point of view, backward compatibility issue would be dirty and troublesome.

The point is, old vMCE interface is host-based while new vMCE is pure s/w defined, hence troubles come from the interface heterogeneous (if need keep compatibility). The basic assumption of live migration from A to B is, A and B basically at same page, so it could be migrated by setting the smallest common feature/capability set (via cpuid, command line, etc.). However, old vMCE and new vMCE are quite different and cannot controlled effectively. For example, old vMCE has MCG_CTL but new vMCE doesn't, and new vMCE has CMCI support (and MCi_CTL2) but old vMCE doesn't. I even doubt the feasibility of keeping compatibility w/ old vMCE. An example is, it's hard to migrate between Intel cpu and AMD cpu.

So I would like to push new vMCE as quickly as possible. What's the timeline of vMCE developing that xen 4.2 could accept? I wonder if we could make major components of vMCE done before xen 4.2 timeline, and leave the surrounding features and the corner cases done later?

Thanks,
Jinsong