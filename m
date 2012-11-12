Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2KLCFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:05:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2KLCFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:05:16 -0500
Message-ID: <50A05955.6040509@gmail.com>
Date: Mon, 12 Nov 2012 10:05:09 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH v3 7/9] trace: use this_cpu_ptr per-cpu helper
References: <509C68C1.3040501@gmail.com> <0000013ae6cfb10f-87b4a0ea-98fe-4269-a834-9ebb64fe61fa-000000@email.amazonses.com>
In-Reply-To: <0000013ae6cfb10f-87b4a0ea-98fe-4269-a834-9ebb64fe61fa-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/10 4:15:
> On Fri, 9 Nov 2012, Shan Wei wrote:
> 
>> -	return buffer->buffer;
>> +	return (char *)this_cpu_ptr(&percpu_buffer->buffer);
>>  }
> 
> Add a comment to explain the cast?

typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
As well-known, the value of &buffer is equal to &buffer[0].
so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid this cast. 

I will submit v4 version patch which improve it.

Thanks~
