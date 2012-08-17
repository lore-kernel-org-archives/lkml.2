Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2HQQ4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:56:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53549 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2HQQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <1345217308.3708.35.camel@gandalf.local.home>
References: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
	<1345217308.3708.35.camel@gandalf.local.home>
Date: Fri, 17 Aug 2012 13:56:07 -0300
Message-ID: <CALF0-+UWkZmAnW0TM0FwLPUp8UKRzBLh1i+5vDih9V8yQ8r+KA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] trace: Move trace event enable from fs_initcall to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tim.bird@am.sony.com,
        lizefan@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-08-17 at 09:03 -0300, Ezequiel Garcia wrote:
>> This patch splits trace event initialization in two stages:
>>  * ftrace enable
>>  * sysfs event entry creation
>>
>> This allows to capture trace events from an earlier point
>> by using 'trace_event' kernel parameter and is important
>> to trace boot-up allocations.
>>
>
> This is much better, I'll give it some tests and add it to my 3.7 queue.
>

Great. Is the event_remove() code, okey? I wasn't too sure about this part.

And also: do you think we could try to only early-enable those events
that were setup with 'trace_event' boot parameter?

I tried but couldn't do it without looping through the complete
__start_ftrace_event array and comparing each entry.

Is this even worthy?

Thanks for reviewing,
Ezequiel.
