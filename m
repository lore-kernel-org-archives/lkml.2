Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1EYGDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:03:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38819 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1EYGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:03:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC9B97.6000605@jp.fujitsu.com>
Date: Wed, 25 May 2011 15:03:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 6:54), Luck, Tony wrote:
> Andi's recovery code can also handle a few cases where the
> error is detected while running kernel code (when copying
> data to/from a user process) - but the TIF_MCE_NOTIFY method
> doesn't actually ever get to this code (since the entry_64.S code
> only checks TIF_MCE_NOTIFY on return to userspace). I'd
> appreciate any ideas on how to handle this. Perhaps we could
> do good things when CONFIG_PREEMPT=y (it seems probable that
> any error in a non-preemtible section of kernel code is going
> to be fatal).

How about separating stuffs in:
 step1) Add support for AR in user space :
   - send sigbus to affected processes, poison affected memory
   - panic if error is in kernel
 step2) Add support for AR in kernel
   - some new notify/handle mechanism etc.

It seems too big jump for me.


Thanks,
H.Seto

