Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1K1RQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:16:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63234 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1K1RQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:16:43 -0500
Message-ID: <4ED3C1F7.5010202@gmail.com>
Date: Mon, 28 Nov 2011 10:16:39 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf tool: reset use_browser when compiled without NEWT
References: <1321913788-2867-1-git-send-email-dsahern@gmail.com> <4ED3BDC6.2080104@gmail.com> <20111128170945.GC12377@infradead.org>
In-Reply-To: <20111128170945.GC12377@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/28/2011 10:09 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 28, 2011 at 09:58:46AM -0700, David Ahern escreveu:
>> Hi Arnaldo:
>>
>> didn't see this one in your queue or a response. Do you agree this is
>> needed?
> 
> Well, I think we should provide a better explanation for this usecase,
> i.e. the code as is will use --stdio in NO_NEWT=yes builds, but will
> still offer --tui and if that is specified, will produce no output.
> 
> Perhaps it is best to either elide --tui in NO_NEWT builds or state that
> the build doesn't support --tui more clearly.
> 
> Or are you seeing something else that you think needs fixing?
>  
> - Arnaldo

In my case I compiled the code on 32-bit RHEL5 with newt disabled. 'perf
report' showed no output unless I added --stdio which seemed silly since
newt was disabled. Adding the  'use_browser = 0' to the setup_browser
fixed it. Doing that mirrors what is done in util/ui/setup.c,
setup_browser() which is used when newt is not disabled compile time:

    if (!isatty(1) || !use_browser || dump_trace) {
        use_browser = 0;
        if (fallback_to_pager)
            setup_pager();
        return;
    }
