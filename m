Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0LRPcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:32:11 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:33745 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0LRPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PZOhaTjVYl2+VxvoXRdQt8t7K6iaJP1QgOFhBRmEedL/w0ryGrtkxCg1kVMBH3YZ6R
         /wcK2UBQCa+H/0bblpCggmZtWH12D09aCX+hyIvOn5H91UH7sNhgB5SC6sf8FXiNU2nW
         IHIF6ublkgr11/vvdQ4Ctp67oakskxRCxCkNw=
Message-ID: <4D0CD3F5.1020401@kernel.org>
Date: Sat, 18 Dec 2010 16:32:05 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
References: <20101214162842.542421046@linux.com> <20101214162854.218751478@linux.com>
In-Reply-To: <20101214162854.218751478@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 05:28 PM, Christoph Lameter wrote:
> The irq work queue is a per cpu object and it is sufficient for
> synchronization if per cpu atomics are used. Doing so simplifies
> the code and reduces the overhead of the code.
> 
> Before:
> 
> christoph@linux-2.6$ size kernel/irq_work.o
>    text	   data	    bss	    dec	    hex	filename
>     451	      8	      1	    460	    1cc	kernel/irq_work.o
> 
> After:
> 
> christoph@linux-2.6$ size kernel/irq_work.o 
>    text	   data	    bss	    dec	    hex	filename
>     438	      8	      1	    447	    1bf	kernel/irq_work.o
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied 3 and 4 to percpu#for-2.6.38.

Thank you.

-- 
tejun
