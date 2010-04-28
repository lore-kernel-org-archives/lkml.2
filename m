Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0D1Pbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:31:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45085 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0D1Pbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:31:46 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1LF47-02-8FC-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 17:31:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
Message-ID: <20100428153116.GF18832@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
 <4BD6DE15.8070409@redhat.com>
 <20100427132030.GH11097@amd.com>
 <4BD6E80A.2000201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD6E80A.2000201@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 15:31:17.0652 (UTC) FILETIME=[D86FCD40:01CAE6E7]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:35:06PM +0300, Avi Kivity wrote:
> Perhaps have
> 
>    struct kvm_mmu base_mmu;
>    struct kvm_mmu nested_mmu;
>    struct kvm_mmu *mmu;

Okay, the pointer is only used in the gva_to_gpa path which is the
minority of mmu context usages. I will introduce a

	struct kvm_mmu *walk_mmu;

and use it in the page walking code.

	Joerg


