Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1KILRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:17:36 -0500
Received: from t111.niisi.ras.ru ([193.232.173.111]:34748 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1KILRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:17:34 -0500
Message-ID: <4EBA6368.6030503@niisi.msk.ru>
Date: Wed, 09 Nov 2011 15:26:32 +0400
From: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Organization: NIISI RAN
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Al Cooper <alcooperx@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Kernel hangs occasionally during boot.
References: <y> <1320764341-4275-1-git-send-email-alcooperx@gmail.com> <20111108175532.GA15493@linux-mips.org> <4EBA2E65.3010009@niisi.msk.ru> <20111109103432.GA27378@linux-mips.org>
In-Reply-To: <20111109103432.GA27378@linux-mips.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2011 14:34, Ralf Baechle wrote:
> Hmm...  Looking at the R4000 manual which generall has the longest
> pipeline hazards, mtc0 gets executed at stage 7, interrupts get sampled
> at stage 3 meaning there is a (7 - 3 - 1) = 3 cycles hazard.  Does
> that one statisfy your constraints?  Or are additional cycles needed
> for a hazard that's generated outside of the CPU's pipeline?
In fact, current back_to_back_hazard is more than enough for cpus I deal 
with. I guess, required time to wait equals number of stages between EX 
(or RD) and WB stages for modern cpus, because CP0 CAUSE is updated 
during WB nowadays.

I suspect, the time required to update internal counter logic for 
original r4k might be bigger though. At least old code waited 12 cycles 
(4*irq_disable_hazard which is 3 for r4k). Perhaps, we should keep this 
code and insert the same amount of nops for old cpus at least.

Regards,
Gleb.
