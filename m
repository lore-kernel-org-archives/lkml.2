Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2EOMSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:18:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34230 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2EOMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:18:30 -0400
X-AuditID: b753bd60-a1c87ba000000655-6d-4fb24993bc36
X-AuditID: b753bd60-a1c87ba000000655-6d-4fb24993bc36
Message-ID: <4FB24991.1040500@hitachi.com>
Date: Tue, 15 May 2012 21:18:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Hyeoncheol Lee <cheol.lee@lge.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [QUESTION] Kprobes as a module?
References: <87zk99zwb8.fsf@sejong.aot.lge.com> <4FB2146E.20101@gmail.com> <87vcjxzvtn.fsf@sejong.aot.lge.com>
In-Reply-To: <87vcjxzvtn.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

No, actually you can't make it as a module.　There are
two major reasons.
 - ftrace depends on the kprobes now.
 - int3 handling routine is deeply depends on
   the architecture. This includes text modifying code.

Thus, if you separate the kprobes into module, that means
you need to expose more ugly interface of self modifying
for kernel modules.

(2012/05/15 17:34), Namhyung Kim wrote:
> Hi,
> 
> On Tue, 15 May 2012 16:31:42 +0800, Cong Wang wrote:
>> On 05/15/2012 04:24 PM, Namhyung Kim wrote:
>>> Hi,
>>>
>>> Probably a dumb question :).
>>> What prevents the kprobes from being built as a module? We want to use
>>> the kprobes on our systems, but some guys worried about potential
>>> security problems. So it'd be great if we can enable/load kprobes as
>>> needed and then disable/unload after using it. Is it a possible senario?

BTW, I'm not sure what the potential security problems on that?
kprobes itself can be used only from kernel modules(except ftrace).
If someone compromises kernel with kernel module, he doesn't need
kprobes at all. They just can do anything they want. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
