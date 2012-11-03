Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab2KCEva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 00:51:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38986 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2KCEv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 00:51:29 -0400
Message-ID: <5094A2CB.8040208@gmail.com>
Date: Sat, 03 Nov 2012 12:51:23 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH 8/9] trace: use this_cpu_ptr per-cpu helper
References: <50910A1E.3040009@gmail.com> <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com> <5093E5FF.5050000@gmail.com> <0000013ac24187fb-694b1865-baeb-4e3b-970e-50bdcd631de7-000000@email.amazonses.com>
In-Reply-To: <0000013ac24187fb-694b1865-baeb-4e3b-970e-50bdcd631de7-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/3 1:53:
> 
> hmm.... what is actually returned is a pointer to char right? And buffer
> is char[1024] so I guess then you need to pass a pointer to char to
> this_cpu_read.
> 
> return this_cpu_read(&(percpu_buffer->buffer))
 
still error....

kernel/trace/trace.c: In function 'get_trace_buf':
kernel/trace/trace.c:1517: error: lvalue required as unary '&' operand
kernel/trace/trace.c:1517: warning: type defaults to 'int' in declaration of 'type name'
kernel/trace/trace.c:1517: warning: cast from pointer to integer of different size
kernel/trace/trace.c:1517: warning: return from incompatible pointer type
kernel/trace/trace.c:1498: warning: unused variable 'buffer'
kernel/trace/trace.c:1517: error: memory input 1 is not directly addressable
kernel/trace/trace.c:1517: error: memory input 1 is not directly addressable

this_cpu_read just read the actual value which a pointer point to.
some case, we just need the pointer.
It's better to use this_cpu_ptr.
return (char *)this_cpu_ptr(&percpu_buffer->buffer);

