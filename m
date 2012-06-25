Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2FYHOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:14:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49027 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2FYHOS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 25 Jun 2012 03:14:18 -0400
Message-Id: <4FE82BE4020000780008B9E3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 25 Jun 2012 08:14:12 +0100
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
 <4FE4B16C020000780008B7A6@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F193234FE@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F193234FE@ORSMSX104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.06.12 at 18:21, "Luck, Tony" <tony.luck@intel.com> wrote:
> There may be some secondary side benefit that independent errors might be
> reported to different banks, and so avoid some overwrite problems.  But I 
> don't
> think that Xen has a big worry with overwrite, does it? In general the 
> errors that
> you will show to the guest are ones that you expect the guest to handle 
> immediately
> (e.g. SRAO and SRAR signaled with a machine check). You do not log any 
> corrected
> errors to the guest (they can't do anything useful with them). You certainly 
> don't
> log any errors that are not signaled. So you should never have any errors 
> hanging
> around in banks for long periods that would get overwritten.

The problem is the determination of what "long" means here. The
target vCPU may not get scheduled for extended periods of time
(raising its priority would have other undesirable implications), so
the risk over overwrite exists from that perspective. However,
assuming that reportable errors get associated with a particular
vCPU, and that such a vCPU won't be able to execute any further
guest code prior to the delivery of the exception, the only real
risk here would be if the vMCE handler itself raised another event.
That I agree with Jinsong can be well treated as fatal (killing the
guest, provided the event gets properly logged so the admin
isn't left in the dark regarding the unexpected death of the VM),
mostly matching would a single bank hardware implementation
would result in.

Jan

