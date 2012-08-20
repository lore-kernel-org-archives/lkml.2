Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2HTCGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:06:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61179 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2HTCGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:06:39 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-5f-50319bad3ecb
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf ui/gtk: Ensure not to call gtk_main_quit() twice
References: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
	<CAOJsxLEZjxa1ySfVJeD-GJ5_Gi=nJTn40rCSu+PHhXjwn633oQ@mail.gmail.com>
	<878vdajpr6.fsf@sejong.aot.lge.com>
	<874nnyjpir.fsf@sejong.aot.lge.com>
Date: Mon, 20 Aug 2012 10:59:41 +0900
In-Reply-To: <874nnyjpir.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 20 Aug 2012 10:55:24 +0900")
Message-ID: <87zk5qiar6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012 10:55:24 +0900, Namhyung Kim wrote:
> On Mon, 20 Aug 2012 10:50:21 +0900, Namhyung Kim wrote:
>> On Sat, 18 Aug 2012 10:52:03 +0300, Pekka Enberg wrote:
>>> Wouldn't it be nicer to rearrange the callers so that perf_gtk__exit()
>>> is not called twice?
>>
>> You mean this?
>>
>>
>> diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
>> index c7820e569660..d25e145e9a89 100644
>> --- a/tools/perf/ui/setup.c
>> +++ b/tools/perf/ui/setup.c
>> @@ -2,6 +2,7 @@
>>  
>>  #include "../cache.h"
>>  #include "../debug.h"
>> +#include "gtk/gtk.h"
>
> Oops, it should be 
>
>    #ifndef NO_GTK2_SUPPORT
>    # include "gtk/gtk.h"
>    #endif
>

Forgot to add the #ifdefery to the below code also. :-/  Anyway, it needs
to expose gtk specifics to general code with the #ifdef's. So I'd still
prefer the original patch.

Thanks,
Namhyung
