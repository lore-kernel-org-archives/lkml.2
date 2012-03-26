Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2CZJqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:46:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37662 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2CZJqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:46:18 -0400
X-AuditID: b753bd60-9bfabba000002f45-0d-4f703ae83083
X-AuditID: b753bd60-9bfabba000002f45-0d-4f703ae83083
Message-ID: <4F703AE6.5020809@hitachi.com>
Date: Mon, 26 Mar 2012 18:46:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        tim.bird@am.sony.com
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com> <4F6A9444.4050603@hitachi.com> <4F6B13BC.2070406@windriver.com> <4F6C83C1.9050704@hitachi.com> <4F6C8AD9.40201@windriver.com>
In-Reply-To: <4F6C8AD9.40201@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/23 23:38), Jason Wessel wrote:
> On 03/23/2012 09:08 AM, Masami Hiramatsu wrote:
>> (2012/03/22 20:57), Jason Wessel wrote:
>>> I will use the arch specific provision to override the
>>> kgdb_arch_set_breakpoint() and use the text_poke() directly.
>>
>> Thanks! that's what I meant. You can use __weak attribute.
>>
> 
> I created and tested a patch yesterday which is show below.  I will
> post a new series at some point soon which addresses this problem as
> well as a number of problems found with the kgdb test suite.

Yeah, that's better.

BTW, I'm not sure the policy of kgdb about mutex, but it seems
that you need to hold a text_mutex when you call the text_poke()
since it uses a fixmap page-area for mapping read-only text page
to writable page. So, without locking (at least ensuring no one
using) text_mutex, it seems not be safe. (some other code may be
trying to change the code by using same fixmap pages)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
