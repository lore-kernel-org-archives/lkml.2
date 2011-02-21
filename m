Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1BURQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:16:41 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:5870 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1BURQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:16:39 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz15d4Rz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGZ9BJ-01-RW1-02
X-M-MSG: 
Date: Mon, 21 Feb 2011 18:16:32 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: X86: Delegate tsc-offset calculation to
 architecture code
Message-ID: <20110221171632.GB16508@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
 <1297272584-22689-6-git-send-email-joerg.roedel@amd.com>
 <4D55B44D.6080208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D55B44D.6080208@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the delay, I had to spend some days sick at home :-( )

On Fri, Feb 11, 2011 at 05:12:29PM -0500, Zachary Amsden wrote:
> On 02/09/2011 12:29 PM, Joerg Roedel wrote:

> So I've gone over this series and the only issue I see so far is with 
> this patch, and it doesn't have to do with upstream code, rather with 
> code I was about to send.
> 
> Logically, the compensation done by adjust_tsc_offset should also be 
> scaled; currently, this happens only for reasons, both of which are 
> meant to deal with unstable TSCs; since TSC scaling won't happen on 
> those processors with unstable TSCs, we don't need to worry about it there.

The tsc_offset is applied after the TSC is scaled so there is no good
way to scale the offset with the TSC value itself.
What we can do is to use guest-tsc values only when we calculate an
adjustment. So any tsc-offset adjustment made with adjust_tsc_offset()
needs to be a function of guest-tsc values. One call-place of the
function already does this and the other one can be converted easily.
I'll do that in the next version of this patch-set.
>From what I understand of your upcoming patch the accumulation of
tsc-offsets could also be calculated from guest-tsc values instead of
native_read_tsc() values, no?

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

