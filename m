Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2ITTOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:14:03 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36247 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2ITTOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <505939EB.8080004@hitachi.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
 <1347574063-22521-2-git-send-email-irina.tirdea@intel.com>
 <87ligd8j46.fsf@sejong.aot.lge.com> <505939EB.8080004@hitachi.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Thu, 20 Sep 2012 22:13:40 +0300
Message-ID: <CANg8OWK4CzLBKnJUd9oa+f5t+5A0htZMORtimcMQgQxcQjzGCw@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf tools: remove sscanf extension %as
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, 14 Sep 2012 01:07:40 +0300, Irina Tirdea wrote:
>>> From: Irina Tirdea <irina.tirdea@intel.com>
>>>
>>> perf uses sscanf extension %as to read and allocate a
>>> string in the same step. This is a non-standard extension
>>> only present in new versions of glibc.
>>>
>>> Replacing the use of sscanf and %as with strtok_r calls
>>> in order to parse a given string into its components.
>>> This is needed in Android since bionic does not support
>>> %as extension for sscanf.
>>>
>>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>>> ---
>>>  tools/perf/util/probe-event.c       |   25 ++++++++++++++++++-------
>>>  tools/perf/util/trace-event-parse.c |   18 ++++++++----------
>>>  2 files changed, 26 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>>> index 4ce04c2..685ddcf 100644
>>> --- a/tools/perf/util/probe-event.c
>>> +++ b/tools/perf/util/probe-event.c
>>> @@ -1100,6 +1100,7 @@ static int parse_probe_trace_command(const char *cmd,
>>>      struct probe_trace_point *tp = &tev->point;
>>>      char pr;
>>>      char *p;
>>> +    char *argv0_str = NULL, *fmt, *fmt1_str, *fmt2_str, *fmt3_str;
>>>      int ret, i, argc;
>>>      char **argv;
>>>
>>> @@ -1116,14 +1117,19 @@ static int parse_probe_trace_command(const char *cmd,
>>>      }
>>>
>>>      /* Scan event and group name. */
>>> -    ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
>>> -                 &pr, (float *)(void *)&tev->group,
>>> -                 (float *)(void *)&tev->event);
>>> -    if (ret != 3) {
>>> +    argv0_str = strdup(argv[0]);
>>
>> It seems you need to check return value of strdup.
>
> Agreed.


Thanks for the review! I'll make the fixes and resend the patch.

Irina
