Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0DWOcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:32:50 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:50243 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0DWOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:32:47 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432P98dN936eMzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1C31C-02-9G7-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 16:31:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: SVM: Fix nested nmi handling
Message-ID: <20100423143159.GJ31537@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
 <1271932394-13968-2-git-send-email-joerg.roedel@amd.com>
 <622FCBB5-826D-4392-A521-7E395507398B@suse.de>
 <20100423141355.GD31537@amd.com>
 <85D89C34-806C-4376-89BA-5BFD413F5396@suse.de>
 <20100423142258.GG31537@amd.com>
 <013159C3-277C-447C-B64B-D2196AF851F9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <013159C3-277C-447C-B64B-D2196AF851F9@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 14:31:59.0833 (UTC) FILETIME=[BBBEF490:01CAE2F1]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 04:24:54PM +0200, Alexander Graf wrote:
> 
> On 23.04.2010, at 16:22, Joerg Roedel wrote:

> > No, nested_svm_nmi runs in atomic context where we can't emulate a
> > vmexit. We set exit_required and emulate the vmexit later.
> 
> So we modify the L2 rflags and then trigger a #vmexit, leaving the l2
> state broken?

No, the rflags are changed in enable_nmi_window which isn't called when
we run nested and the nested hypervisor intercepts nmi. So it only runs
in the !nested case where it can't corrupt L2 state.

	Joerg


