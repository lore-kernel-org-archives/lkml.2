Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0LGPRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:17:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0LGPRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:17:35 -0500
Message-ID: <4CFE4FB4.9070408@kernel.org>
Date: Tue, 07 Dec 2010 16:16:04 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 10/11] fs: Use this_cpu_xx operations in buffer.c
References: <20101206171618.302060721@linux.com> <20101206171642.042645708@linux.com>
In-Reply-To: <20101206171642.042645708@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 15:16:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> Optimize various per cpu area operations through the new this cpu
> operations. These operations avoid address calculations through the use
> of segment prefixes avoid multiple memory references through RMW
> instructions etc.
> 
> Reduces code size:
> 
> Before:
> 
> christoph@linux-2.6$ size fs/buffer.o
>    text	   data	    bss	    dec	    hex	filename
>   19169	     80	     28	  19277	   4b4d	fs/buffer.o
> 
> After:
> 
> christoph@linux-2.6$ size fs/buffer.o
>    text	   data	    bss	    dec	    hex	filename
>   19138	     80	     28	  19246	   4b2e	fs/buffer.o
> 
> V3->V4:
> 	- Move the use of this_cpu_inc_return into a later patch so that
> 	  this one can go in without percpu infrastructure changes.
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Lameter <cl@linux.com>

applied 10 and 11.

-- 
tejun
