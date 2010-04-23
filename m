Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0DWOVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:21:35 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45642 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0DWOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:21:33 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432P98dN936eM4015L10d1Izz1202hzzz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C2JL-01-6QT-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:21:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 6/8] KVM: SVM: Report emulated SVM features to userspace
Message-ID: <20100423142119.GF31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-7-git-send-email-joerg.roedel@amd.com>
 <60EF3E44-A41C-418E-9B03-8C245CA50699@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <60EF3E44-A41C-418E-9B03-8C245CA50699@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:21:20.0060 (UTC) FILETIME=[3E6957C0:01CAE2F0]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 03:55:15PM +0200, Alexander Graf wrote:
> 
> On 22.04.2010, at 12:33, Joerg Roedel wrote:
> > static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > {
> > +	switch (func) {
> > +	case 0x8000000A:
> > +		entry->eax = 1; /* SVM revision 1 */
> > +		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> > +				   ASID emulation to nested SVM */
> 
> I completely forgot what we do now. What do we do? It shouldn't be too
> hard to keep a table around and just assign 8 host ASIDs to the guest.
> If possible lazily, so we can just flush the whole thing when we run
> out of entries.

Currently we have no ASID emulation. We just assign a new asid at every
vmrun/vmexit. But I have a rough idea of how we can emulate ASIDs for
the L2 guest with an per-vcpu ASID cache.

> It's basically the same as my VSID mapping on ppc64 actually. See
> arch/powerpc/kvm/book3s_64_mmu_host.c and search for "slb".

Thanks, will have a look there.

> > +		entry->ecx = 0; /* Reserved */
> > +		entry->edx = 0; /* Do not support any additional features */
> 
> What about nnpt? Hasn't that been accepted yet?

I am currently working on it. If all goes well I can submit a new
version next week.

	Joerg


