Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1DGDSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:18:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1DGDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pVRG2TNglE/Nrm0tAgg0Vsje3/sVC19D7s+buqUtLDvHow26uOkVYMJ1ZGI84fxWlJ
         yZNer7i2PswoTUsLv13A==
MIME-Version: 1.0
In-Reply-To: <20110407013349.GH1867@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com> <20110407013349.GH1867@nowhere>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 6 Apr 2011 20:17:33 -0700
Message-ID: <BANLkTinKsYqkEEUu98t+Gn9ciPn_bmsMFQ@mail.gmail.com>
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        Michael Rubin <mrubin@google.com>, Ken Chen <kenchen@google.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 6:33 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Apr 06, 2011 at 11:50:21AM -0700, Vaibhav Nagarnaik wrote:
>> All
>> The cgroup functionality is being used widely in different scenarios. It also
>> is being integrated with other parts of kernel to take advantage of its
>> features. One of the areas that is not yet aware of cgroup functionality is
>> the ftrace framework.
>>
>> Although ftrace provides a way to filter based on PIDs of tasks to be traced,
>> it is restricted to specific tracers, like function tracer. Also it becomes
>> difficult to keep track of all PIDs in a dynamic environment with processes
>> being created and destroyed in a short amount of time.
>>
>> An application that creates many processes/tasks is convenient to track and
>> control with cgroups, but it is difficult to track these processes for the
>> purposes of tracing. And if child processes are moved to another cgroup, it
>> makes sense to trace only the original cgroup.
>>
>> This proposal is to create a file in the tracing directory called
>> set_trace_cgroup to which a user can write the path of an active cgroup, one
>> at a time. If no cgroups are specified, no filtering is done and all tasks are
>> traced. When a cgroup path is added in, it sets a boolean tracing_enabled for
>> the enabled cgroup in all the hierarchies, which enables tracing for all the
>> assigned tasks under the specified cgroup.
>>
>> Though creating a new file in the directory is not desirable, but this
>> interface seems the most appropriate change required to implement the new
>> feature.
>>
>> This tracing_enabled flag is also exported in the cgroupfs directory structure
>> which can be turned on/off for a specific hierarchy/cgroup combination. This
>> gives control to enable/disable tracing over a cgroup in a specific hierarchy
>> only.
>>
>> This gives more fine-grained control over the tasks being traced. I would like
>> to know your thoughts on this interface and the approach to make tracing
>> cgroup aware.
>
> So I have to ask, why can't you use perf events to do tracing limited on cgroups?
> It has this cgroup context awareness.
>

The perf event cgroup awareness comes from creating a different hierarchy for
perf events. When the events and the current task's cgroup match, the events
are logged. So the changes are pretty specific to the perf events.

Even in the case where changes are made to handle trace events, the interface
files are still needed. The interface used to specify perf events uses the
perf_event syscall which isn't available to specify trace events.

This is based on my limited understanding of the perf_events cgroup awareness
patch. Please correct me if I am missing anything.

Thanks

Vaibhav Nagarnaik
