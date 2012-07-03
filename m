Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2GCOuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:50:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:39400
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551Ab2GCOuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:50:02 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzzz2dh668h839hd25he5bhf0ah)
X-WSS-ID: 0M6LAJ8-02-CIW-02
X-M-MSG: 
Message-ID: <4FF306C1.7000100@amd.com>
Date: Tue, 3 Jul 2012 16:50:41 +0200
From: Christoph Egger <Christoph.Egger@amd.com>
User-Agent: Mozilla/5.0 (X11; NetBSD amd64; rv:11.0) Gecko/20120404 Thunderbird/11.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Jan Beulich <JBeulich@suse.com>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        IanCampbell <Ian.Campbell@citrix.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KeirFraser <keir@xen.org>
Subject: Re: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com> <4FEB236C020000780008C392@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com> <4FEC3B4A020000780008C673@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com> <4FEC463E020000780008C6A7@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com> <4FEC7FB8020000780008C885@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com> <4FED7C5F.1040908@amd.com> <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com> <4FF2B87C020000780008D3E0@nat28.tlf.novell.com> <3908561D78D1C84285E8C5FCA982C28F1933C278@ORSMSX104.amr.corp.intel
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1933C278@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/12 15:26, Luck, Tony wrote:

>> I'm not convinced of the need, and would prefer aiming at a
>> shared implementation unless issues arise that make this
>> impossible.
> 
> It does sound odd. Yes, Intel and AMD have differences around CMCI ... but we are never
> going to send a CMCI to a guest (there is no point, it can't do anything useful with the
> information, it may do something pointlessly stupid like stop using a guest physical page).
> The only reason I suggested making MCG_CAP pretend that CMCI was supported was a
> small optimization ... if a Linux guest sees that CMCI is supported, it will not poll the machine
> check banks looking for corrected errors.


Are you talking about PV or HVM guest?

For HVM guests yes it makes sense to disable CMCI in MCG_CAP for both
AMD and Intel.

PV guests never read MCE MSRs directly. They install a trap handler and
use the hypercall to fetch the error telemetry. The xen interface is
common to both AMD and Intel - it's basically just an array of bytes.
The first bytes tell you how you can cast and interpret the bytes.
That *content* is specific to AMD or Intel.

How much logic can be shared is almost a matter of software design
and not hardware design.

Christoph

-- 
---to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Einsteinring 24, 85689 Dornach b. Muenchen
Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

