Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2KBP0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:26:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37492 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2KBP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:26:12 -0400
Message-ID: <5093E5FF.5050000@gmail.com>
Date: Fri, 02 Nov 2012 23:25:51 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH 8/9] trace: use this_cpu_ptr per-cpu helper
References: <50910A1E.3040009@gmail.com> <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com>
In-Reply-To: <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/1 1:50:
>>
>> -	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
>> +	buffer = this_cpu_ptr(percpu_buffer);
>>
>>  	return buffer->buffer;
> 
> 
> Just do a
> 
> 	return this_cpu_read(percpu_buffer->buffer);
> 
> and get rid of the this_cpu_ptr op

can not do that.
kernel/trace/trace.c:1515: error: incompatible types when assigning to type 'char[1024]' from type 'char *'

 

