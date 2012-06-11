Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2FKEsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:48:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51582 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FKEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:48:23 -0400
X-AuditID: 9c93016f-b7c3cae000001954-4c-4fd578957b48
From: Namhyung Kim <namhyung@kernel.org>
To: Shan Wei <shanwei88@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung.kim@lge.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Samuel Liao <samuelliao@tencent.com>
Subject: Re: [Perf bug-fix] check null of sym pointer before using it
References: <4FCD95D3.90209@gmail.com> <4FD552CE.5020303@gmail.com>
Date: Mon, 11 Jun 2012 13:45:17 +0900
In-Reply-To: <4FD552CE.5020303@gmail.com> (Shan Wei's message of "Mon, 11 Jun
	2012 10:07:10 +0800")
Message-ID: <87y5nupici.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 11 Jun 2012 10:07:10 +0800, Shan Wei wrote:
> ping.....
>
> It's a obvious function bug.....
>
> Shan Wei said, at 2012/6/5 13:14:
>
>> From: Samuel Liao <samuelliao@tencent.com>
>> 
>> Sometimes, sym will be null that causing perf crash.
>> 
>> Signed-off-by: Shan Wei <davidshan@tencent.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks for the fix.
Namhyung


>> ---
>>  tools/perf/ui/browsers/annotate.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>> 
>> diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
>> index 4deea6a..50873a8 100644
>> --- a/tools/perf/ui/browsers/annotate.c
>> +++ b/tools/perf/ui/browsers/annotate.c
>> @@ -814,7 +814,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>>  {
>>  	struct disasm_line *pos, *n;
>>  	struct annotation *notes;
>> -	const size_t size = symbol__size(sym);
>> +	size_t size;
>>  	struct map_symbol ms = {
>>  		.map = map,
>>  		.sym = sym,
>> @@ -834,6 +834,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
>>  	if (sym == NULL)
>>  		return -1;
>>  
>> +	size = symbol__size(sym);
>> +
>>  	if (map->dso->annotate_warned)
>>  		return -1;
>>  
