Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2ECUtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:49:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab2ECUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:49:46 -0400
Message-ID: <4FA2EF67.9070107@gmail.com>
Date: Thu, 03 May 2012 14:49:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] perf target: Introduce perf_target_errno
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com> <1335417327-11796-10-git-send-email-namhyung.kim@lge.com> <20120502185913.GE5745@infradead.org> <4FA2EBCC.5060905@gmail.com> <20120503204212.GC8807@infradead.org>
In-Reply-To: <20120503204212.GC8807@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/12 2:42 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 03, 2012 at 02:34:20PM -0600, David Ahern escreveu:
>> On 5/2/12 12:59 PM, Arnaldo Carvalho de Melo wrote:
>>> Also it would be better to have it as PERF_ERRNO__PID_OVERRIDE_CPU, etc.
>>
>> I thought you wanted subsystem based errno's (PERF_TARGET__XXXXX)
>> versus one big set (PERF_ERRNO__XXXXX). Did you change your mind?
>
> Oops, I didn't realize PID being the subsys, then yeah, that is ok.
>
> But that would make it PERF_ERR__TARGET_, as PERF_TARGET__ doesn't
> straight away brings back "error enumeration", at least for me :)
>
> But this is getting overly long, ideas?
>
> PERF_ we need, its libperf's "namespace", then ERRNO looks needed too,
> heck, make it long:
>
> PERF_ERRNO_TARGET__PID_OVERRIDE_CPU
>
> After all most of the time this will just be inside the function setting
> the error and the strerrno function that will convert this to an string,
> right?

Agreed, the long macro name shouldn't be visible outside of the depths 
of the perf files that set it and convert it to a string.

David
