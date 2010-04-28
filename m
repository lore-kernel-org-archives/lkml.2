Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0D1KwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:52:17 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:5445 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752272Ab0D1KwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:52:14 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM9371Pzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1L26T-02-833-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 12:52:01 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/22] KVM: MMU: Add infrastructure for two-level page
 walker
Message-ID: <20100428105201.GC18832@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-12-git-send-email-joerg.roedel@amd.com>
 <4BD6D9C2.6020104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6D9C2.6020104@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 10:52:02.0533 (UTC) FILETIME=[D59B8950:01CAE6C0]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:34:10PM +0300, Avi Kivity wrote:
> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> >This patch introduces a mmu-callback to translate gpa
> >addresses in the walk_addr code. This is later used to
> >translate l2_gpa addresses into l1_gpa addresses.
> >
> >+static inline gfn_t gpa_to_gfn(gpa_t gpa)
> >+{
> >+	return (gfn_t)gpa>>  PAGE_SHIFT;
> >+}
> >+
> 
> This overflows on 32-bit, since gpa_t is u64 and gfn_t is ulong.

Hm, this is a problem outside of this patchset too (for 32bit hosts).
The best solution is probably to convert gfn_t to u64 too.

	Joerg


