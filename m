Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab2F1JIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:08:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43838 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab2F1JIT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 28 Jun 2012 05:08:19 -0400
Message-Id: <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 28 Jun 2012 10:08:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>, "Will Auld" <will.auld@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: RE: [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.06.12 at 10:54, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Jan Beulich wrote:
>> The 2-bank approach also needs to be brought in line with the
>> current host derived value in MCG_CAP, especially if the code to
>> implement this new model doesn't make it into 4.2 (which would
>> generally save a larger value).
> 
> Let me repeat in my word to avoid misunderstanding about your concern:
> Your concern rooted from the history patch (c/s 24887, as attached) which 
> used to solve vMCE migration issue caused from bank number. I guess the patch 
> was not in xen4.1.x but would be in xen 4.2 release recently (right? and when 
> will xen 4.2 release?)

4.2 is in feature freeze right now, preparing for the release.

> Per my understanding, you want us to make sure our new vMCE model compatible 
> w/ olde vMCE. For example if our patch in xen 4.3 release, you want to make 
> sure a guest migrate from xen 4.2 to 4.3 would not broken. Is this your 
> concern?

Yes. If we can't get the save/restore records adjusted in time
for 4.2, compatibility with 4.2 would be a requirement. If we
manage to get the necessary adjustments done in time, and if
they're not too intrusive (i.e. would be acceptable at this late
stage of the development cycle), then the concern could be
dropped from an upstream perspective due to the lack of
support in 4.1 (and hence no backward compatibility issues).
BUT this isn't as simple from a product usage point of view: As
the save/restore code currently in -unstable was coded up to
address a problem observed by SLE11 SP2 users, we already
backported those patches. So compatibility will be a requirement
in any case.

Jan

