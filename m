Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab1LNQJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:09:42 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48609 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:09:41 -0500
Date: Wed, 14 Dec 2011 17:09:29 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] x86, mce: create helper function to save addr/misc
 when needed
Message-ID: <20111214160929.GI23589@aftab>
References: <e7943938-eaae-41c4-a7e6-272f0832495f@DB3EHSMHS002.ehs.local>
 <20111213144948.GH15077@aftab>
 <0207C53569FE594381A4F2EB66570B2A018F05A9FB@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018F05A9FB@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 09:44:07AM -0800, Luck, Tony wrote:
> > Am I reading this correctly in that you need to cut off the same amount
> > of bits on both sides of MCi_ADDR and the address magnitude coincides
> > with the left shift amount? I.e. and for example, if MCi_ADDR[44:3]
> > and you need to cut off 3 bits of both sides to get a 48-bit physical
> > address?
> 
> No - just masking bits at the low end (shift right and the bits we don't
> want fall into the bit bucket, shift left by the same amount and we fill
> those spots with zeroes).  Upper bits are unchanged.

Doh, of course, I must be drunk. Please disregard this comment.

> 
> I could write it as:
> 			m->addr &= ~((1ull << shift) - 1);

> 
> But I think the shift-right, shift-left is used elsewhere in the kernel too.

No, yours is fine.

ACK.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
