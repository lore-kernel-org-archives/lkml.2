Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1DGBeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:34:02 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58461 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab1DGBeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dETvXz7RtpWFzoRbZWUVTf/M26U2HyyuWwa4oP0e8x66gtU6jGbOJzoAXGq6wv0aDU
         wja7jsLI0gUdQEftmRQJWQCDBF+nfpBrY09Fhqqi8sXznVLpoXJk9U6muqICuOVW1O0H
         oBYVfvIT+svQK904rGznApEmuKl1S2f3wpV5c=
Date: Thu, 7 Apr 2011 03:33:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC] tracing: Adding cgroup aware tracing functionality
Message-ID: <20110407013349.GH1867@nowhere>
References: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik_jtjWTsOueUzfdQXRx17OcgyDgA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:50:21AM -0700, Vaibhav Nagarnaik wrote:
> All
> The cgroup functionality is being used widely in different scenarios. It also
> is being integrated with other parts of kernel to take advantage of its
> features. One of the areas that is not yet aware of cgroup functionality is
> the ftrace framework.
> 
> Although ftrace provides a way to filter based on PIDs of tasks to be traced,
> it is restricted to specific tracers, like function tracer. Also it becomes
> difficult to keep track of all PIDs in a dynamic environment with processes
> being created and destroyed in a short amount of time.
> 
> An application that creates many processes/tasks is convenient to track and
> control with cgroups, but it is difficult to track these processes for the
> purposes of tracing. And if child processes are moved to another cgroup, it
> makes sense to trace only the original cgroup.
> 
> This proposal is to create a file in the tracing directory called
> set_trace_cgroup to which a user can write the path of an active cgroup, one
> at a time. If no cgroups are specified, no filtering is done and all tasks are
> traced. When a cgroup path is added in, it sets a boolean tracing_enabled for
> the enabled cgroup in all the hierarchies, which enables tracing for all the
> assigned tasks under the specified cgroup.
> 
> Though creating a new file in the directory is not desirable, but this
> interface seems the most appropriate change required to implement the new
> feature.
> 
> This tracing_enabled flag is also exported in the cgroupfs directory structure
> which can be turned on/off for a specific hierarchy/cgroup combination. This
> gives control to enable/disable tracing over a cgroup in a specific hierarchy
> only.
> 
> This gives more fine-grained control over the tasks being traced. I would like
> to know your thoughts on this interface and the approach to make tracing
> cgroup aware.

So I have to ask, why can't you use perf events to do tracing limited on cgroups?
It has this cgroup context awareness.
