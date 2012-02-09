Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2BIGEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:04:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45856 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2BIGEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:04:11 -0500
Message-ID: <4F3361D7.4020203@gmail.com>
Date: Wed, 08 Feb 2012 23:04:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in record,
 stat, top
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <4F331F14.5070100@gmail.com> <4F3334F7.70809@gmail.com> <4F335B69.8060701@gmail.com>
In-Reply-To: <4F335B69.8060701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 10:36 PM, Namhyung Kim wrote:
> Oh, I meant this:
> 
> static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
> {
> 	...
> 	while (*str) {
> 		...
> 		tmp = thread_map__new_by_pid(pid);
> 		...
> 	}
> 	...
> }
> 
> static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
> {
> 	...
> 	while (*str) {
> 		...
> 		tmp = thread_map__new_by_tid(tid);
> 		...
> 	}
> 	...
> }


I'm still not seeing the code simplification here. For example,
new_by_tid(tid) allocates threads, sets the first element (it only
supports one) and returns it. In new_by_tid_str we loop over a CSV,
allocating/re-allocating on additional and then setting the current i-th
tid as opposed to the 0th element.

Similarly, for pid.

Personally, I liked my first patch better which dropped the current
tid/pid functions; they are only used by perf-test and it can be updated
to convert getpid() to a string and use the new API.

David
