Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2BMSuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:50:35 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54329 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab2BMSud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:50:33 -0500
Message-ID: <4F395B75.4060800@gmail.com>
Date: Mon, 13 Feb 2012 11:50:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] perf tools: Introduce struct perf_maps_opts
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com> <1329118064-9412-2-git-send-email-namhyung.kim@lge.com> <20120213183232.GD15955@infradead.org>
In-Reply-To: <20120213183232.GD15955@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/13/2012 11:32 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 13, 2012 at 04:27:33PM +0900, Namhyung Kim escreveu:
>> The perf_maps_opts struct will be used for taking care of cpu/thread
>> maps based on user's input. Since it is used on various subcommands
>> it'd be better factoring it out.
> 
> I think 'struct perf_target' is a better name than 'struct
> perf_maps_opts'.
> 
> Then you can remove the 'target_' prefix from pid and tid:
> 
> struct perf_target {
> 	pid_t	     pid;
> 	pid_t	     tid;
> 	uid_t	     uid;
> 	const char   *cpu_list;
> 	const char   *uid_str;
> 	bool	     system_wide;
> };
> 
> Also bear in mind that this patch will clash with David Ahern's patch
> for supporting pid and tid lists, I'll try to integrate it today and
> then you can work on top of it in my perf/core branch, ok?
> 
> Now to the other patches...
> 
> - Arnaldo
>  

The cleanup might make my multiple tid/pid patch easier: e.g.,

struct perf_target{
	...
	char errmsg[128];
};

Then if the tid/pid string parsing fails in perf_evlist__create_maps and
friends the errmsg can be put into the buffer for the callers to get a
more useful message to the user as to what happened.

Today's perf if you give it an invalid pid, scandir fails and the
command spits out the usage statement. Which is completely confusing --
ie., not clear that the command failed b/c the pid does not exist.

David
