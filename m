Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1CXPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:40:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42701 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1CXPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A9MTrtenaqBWD1TJFeEUepY5cVanRpXzmX80GA+p8nXxpnC61T4KpUCdYia5P2eJ95
         jK1Klna8cwSK95nG9TZDSKVVklg/wHl9Rqulzd95s3w502nFL6c+TohyIbPEhCiiCLqn
         L5DA/2CFwQOo/5152Y2bUK7xL4xj1jokf2QTo=
Message-ID: <4D8B6569.2030001@gmail.com>
Date: Thu, 24 Mar 2011 18:38:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com> <20110324084819.GH30812@elte.hu>
In-Reply-To: <20110324084819.GH30812@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 11:48 AM, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> Don, I've added yours SOB, ok? (The patch is attached to avoid
>> space/tabs problem
>> due to web-mail client)
> 
> The patch lacks a proper description about the motivation and effects of the 
> patch.
> 
> Thanks,
> 
> 	Ingo

Ingo, does this one looks better?

---
From: Don Zickus <dzickus@redhat.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Add missing read of MSR register to catch unflagged overflows

The read of a proper MSR register was missed so instead of a counter the
configration register is tested (it has ARCH_P4_UNFLAGGED_BIT always
cleared) and unflagged overflows never have been catched. Fix it by
reading a proper MSR register.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;


-- 
    Cyrill
