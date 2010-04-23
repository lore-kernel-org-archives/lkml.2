Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0DWO1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:27:18 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:24771
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862Ab0DWO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:27:16 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C2T3-02-93E-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:27:03 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] KVM: x86: Allow marking an exception as reinjected
Message-ID: <20100423142702.GH31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-8-git-send-email-joerg.roedel@amd.com>
 <46B1F208-76A4-4C2F-9AE7-789264AB2D4B@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <46B1F208-76A4-4C2F-9AE7-789264AB2D4B@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:27:03.0377 (UTC) FILETIME=[0B0B5C10:01CAE2F1]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 03:57:32PM +0200, Alexander Graf wrote:
> 
> On 22.04.2010, at 12:33, Joerg Roedel wrote:
> 
> > This patch adds logic to kvm/x86 which allows to mark an
> > injected exception as reinjected. This allows to remove an
> > ugly hack from svm_complete_interrupts that prevented
> > exceptions from being reinjected at all in the nested case.
> > The hack was necessary because an reinjected exception into
> > the nested guest could cause a nested vmexit emulation. But
> > reinjected exceptions must not intercept. The downside of
> > the hack is that a exception that in injected could get
> > lost.
> > This patch fixes the problem and puts the code for it into
> > generic x86 files because. Nested-VMX will likely have the
> > same problem and could reuse the code.
> 
> So we always handle the reinjection from KVM code? Shouldn't the l1
> hypervisor do this?

No. We only have the problem if we need to handle a nested intercept on
the host level instead of reinjecting it. So the nested hypervisor
couldn't be involved in the reinjection.

	Joerg


