Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1F3Pmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:42:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1F3Pmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:42:47 -0400
Message-ID: <4E0C9971.5040605@gmail.com>
Date: Thu, 30 Jun 2011 09:42:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip 3/4] perf script: add the option to show the offset
 of symbols
References: <20110628074019.4269.32109.stgit@linux3> <20110628074044.4269.40422.stgit@linux3> <4E09EA90.8040801@gmail.com> <4E09EB66.6050406@gmail.com> <4E0BFF2D.6040108@hitachi.com>
In-Reply-To: <4E0BFF2D.6040108@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 10:44 PM, Akihiro Nagai wrote:
>>>> @@ -346,12 +348,15 @@ static void print_sample_addr(union perf_event
>>>> *event,
>>>>           al.sym = map__find_symbol(al.map, al.addr, NULL);
>>>>
>>>>       if (PRINT_FIELD(SYM)) {
>>>> -        if (al.sym&&  al.sym->name)
>>>> +        printf(" ");
>>>> +        if (al.sym&&  al.sym->name) {
>>>>               symname = al.sym->name;
>>>> -        else
>>>> -            symname = "";
>>>
>>> dropping the else path will cause columns to misalign when ip's do not
>>> resolve.
> I see.
> I'd like to add a magic word that indicates perf-script failed to
> resolve the symbol.
> For example, '[unknown]'.

ok. constant number of fields would make secondary analysis tools easier.

David
