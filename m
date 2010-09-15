Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0IOIvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:51:54 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21326 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0IOIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:51:52 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i2a8h87h43h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8S5RM-02-876-02
X-M-MSG: 
Date: Wed, 15 Sep 2010 10:48:33 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: Use base_role.nxe for mmu.nx
Message-ID: <20100915084833.GH17759@amd.com>
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
 <1284479173-4515-3-git-send-email-joerg.roedel@amd.com>
 <20100914220836.GA3553@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100914220836.GA3553@amt.cnet>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 06:08:37PM -0400, Marcelo Tosatti wrote:
> 
> For tdp better set base_role.nxe to zero, otherwise duplicate tdp
> pagetables can be created if the guest switches between nx/non-nx.
>

This does not work because bit 63 is marked as reserved if base_role.nxe
is 0. If the walk_addr_generic function then runs with tdp enabled it
would report a set nx bit as a rsvd fault.
We also can't use is_nx() in those path because it does not distinguish
between l1 and l2 nx. Are there guests that switch the efer.nx bit
regularly enough so that it matters? If so I would suggest to drop this
patch and keep mmu.nx.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

