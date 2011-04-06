Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1DFSu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:50:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1DFSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Ov9VtEnLf9I1P/NQdcEtjTXS6W7sN7ML0PS1hklofv10IUVZKWrc84XsMCMk1JkbU9
         O7CKEM83VmWlFE/ezfxw==
MIME-Version: 1.0
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 6 Apr 2011 11:50:21 -0700
Message-ID: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
Subject: [RFC] tracing: Adding cgroup aware tracing functionality
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All

The cgroup functionality is being used widely in different scenarios. It also
is being integrated with other parts of kernel to take advantage of its
features. One of the areas that is not yet aware of cgroup functionality is
the ftrace framework.

Although ftrace provides a way to filter based on PIDs of tasks to be traced,
it is restricted to specific tracers, like function tracer. Also it becomes
difficult to keep track of all PIDs in a dynamic environment with processes
being created and destroyed in a short amount of time.

An application that creates many processes/tasks is convenient to track and
control with cgroups, but it is difficult to track these processes for the
purposes of tracing. And if child processes are moved to another cgroup, it
makes sense to trace only the original cgroup.

This proposal is to create a file in the tracing directory called
set_trace_cgroup to which a user can write the path of an active cgroup, one
at a time. If no cgroups are specified, no filtering is done and all tasks are
traced. When a cgroup path is added in, it sets a boolean tracing_enabled for
the enabled cgroup in all the hierarchies, which enables tracing for all the
assigned tasks under the specified cgroup.

Though creating a new file in the directory is not desirable, but this
interface seems the most appropriate change required to implement the new
feature.

This tracing_enabled flag is also exported in the cgroupfs directory structure
which can be turned on/off for a specific hierarchy/cgroup combination. This
gives control to enable/disable tracing over a cgroup in a specific hierarchy
only.

This gives more fine-grained control over the tasks being traced. I would like
to know your thoughts on this interface and the approach to make tracing
cgroup aware.


Thanks

Vaibhav Nagarnaik
