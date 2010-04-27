Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0D0Q2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:28:09 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:43917
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752916Ab0D0Q2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:28:06 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P98dN936eM179dN9371Pzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1JN2B-01-0RD-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 18:27:45 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
Message-ID: <20100427162745.GA18832@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
 <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
 <4BD6DE15.8070409@redhat.com>
 <20100427132030.GH11097@amd.com>
 <4BD6E80A.2000201@redhat.com>
 <20100427154024.GL11097@amd.com>
 <4BD70C41.2060202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD70C41.2060202@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 16:27:45.0941 (UTC) FILETIME=[9199EC50:01CAE626]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 07:09:37PM +0300, Avi Kivity wrote:
> On 04/27/2010 06:40 PM, Joerg Roedel wrote:
> >
> >Currently its a bit unclear when to use mmu or nested_mmu. With a
> >pointer it would be unclear to the code reader when to use the pointer
> >and when to select the mmu_contexts directly.
> 
> I think in most cases you'd want full translation, thus the pointer.
> This should be the default.  In specific cases you'd want just the
> non-nested guest translation.

Hmm, for most cases == all gva_to_gpa cases. The page fault path can't
use the pointer. I'll try out how this works. It shouldn't be too
complicated.

	Joerg


