Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2EOIbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:31:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab2EOIbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:31:47 -0400
Message-ID: <4FB2146E.20101@gmail.com>
Date: Tue, 15 May 2012 16:31:42 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Hyeoncheol Lee <cheol.lee@lge.com>
Subject: Re: [QUESTION] Kprobes as a module?
References: <87zk99zwb8.fsf@sejong.aot.lge.com>
In-Reply-To: <87zk99zwb8.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 04:24 PM, Namhyung Kim wrote:
> Hi,
>
> Probably a dumb question :).
> What prevents the kprobes from being built as a module? We want to use
> the kprobes on our systems, but some guys worried about potential
> security problems. So it'd be great if we can enable/load kprobes as
> needed and then disable/unload after using it. Is it a possible senario?
>

Kconfig prevents that:

config KPROBES
         bool "Kprobes"
         depends on MODULES
         depends on HAVE_KPROBES
         select KALLSYMS


so you can have either CONFIG_KPROBES=y or CONFIG_KPROBES=n, but not =m.
