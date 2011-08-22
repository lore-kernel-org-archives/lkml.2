Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1HVUg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:36:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48727 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1HVUg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:36:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jOtOcn6ZXgRw/GgXMehhT5QT5PVncXKyeNYOZEdkcoV48VqIfgSxWFUTeeMvqlNE8
	L9/knylSgENgS7hDU4eng==
MIME-Version: 1.0
In-Reply-To: <1314044981.15704.140.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1313531179-9323-4-git-send-email-vnagarnaik@google.com> <1314044981.15704.140.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 22 Aug 2011 13:36:24 -0700
Message-ID: <CAL26m8+2shZFfsrgji_zTVijBWMs3zCp_smRdTy1NiJQfTcKew@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] trace: Add per_cpu ring buffer control files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 1:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-08-16 at 14:46 -0700, Vaibhav Nagarnaik wrote:
>> Add a debugfs entry under per_cpu/ folder for each cpu called
>> buffer_size_kb to control the ring buffer size for each CPU
>> independently.
>>
>> If the global file buffer_size_kb is used to set size, the individual
>> ring buffers will be adjusted to the given size. The buffer_size_kb will
>> report the common size to maintain backward compatibility.
>>
>> If the buffer_size_kb file under the per_cpu/ directory is used to
>> change buffer size for a specific CPU, only the size of the respective
>> ring buffer is updated. When tracing/buffer_size_kb is read, it reports
>> 'X' to indicate that sizes of per_cpu ring buffers are not equivalent.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>
> This patch wasn't tested against any of the latency tracers being
> enabled or hot plug:
>
>
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c: In function 'ring_buffer_swap_cpu':
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c:3761:14: error: 'struct ring_buffer' has no member named 'pages'
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c:3761:33: error: 'struct ring_buffer' has no member named 'pages'
>  CC      kernel/trace/trace_syscalls.o
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c: In function 'rb_cpu_notify':
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c:4136:4: error: too few arguments to function 'rb_allocate_cpu_buffer'
> /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/ring_buffer.c:1066:1: note: declared here
>
>
> -- Steve

Oops, sorry about that. I will send a respin of the patch.


Vaibhav Nagarnaik
