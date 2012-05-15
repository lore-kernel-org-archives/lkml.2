Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2EOB4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:56:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55307 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2EOB4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:56:01 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-aa-4fb1b7ae3bc4
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Lucas Meneghel Rodrigues <lmr@redhat.com>
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
	<87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com>
	<87k40e1cco.fsf@sejong.aot.lge.com> <4FB1B486.4020509@gmail.com>
	<20120515014633.GD4254@infradead.org>
Date: Tue, 15 May 2012 10:54:21 +0900
In-Reply-To: <20120515014633.GD4254@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 14 May 2012 22:46:33 -0300")
Message-ID: <87fwb21a5u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 14 May 2012 22:46:33 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 14, 2012 at 07:42:30PM -0600, David Ahern escreveu:
>> On 5/14/12 7:07 PM, Namhyung Kim wrote:
>> >>Something else is wrong then. I tested that command (saw your patch in
>> >>the history) and it worked for me. Also, this code path does not
>> >>affect perf-stat -- it touches perf-record and perf-test only.
>
>> >Ah, right. But still wouldn't it be better changing the conditional
>> >rather than disabling it unconditionally?
>
>> I think it would be best to disable all events initially and then
>> enable them when ready. It works for perf-record and perf-test just
>> fine and limits the samples to what you care about.
>
> And we need to have all this logic in a central place, the "open" method
> of perf_evlist :-)
>

Agreed. So we need to make it generic to suitable for perf-stat and
perf-top (and others?) also.


> The perf_target abstraction is the way to get there, but in the process
> I think we really need to have each new method with a 'perf test' entry
> and in addition to that an 'autotest'* entry to test the perf builtins.
>
> - Arnaldo
>
> * http://autotest.github.com/

I'll have a look at it.

Thanks,
Namhyung
