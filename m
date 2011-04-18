Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1DRVDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:03:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49409 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1DRVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:03:20 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel>
	 <alpine.DEB.2.00.1104161653220.14788@chino.kir.corp.google.com>
	 <1303139455.9615.2533.camel@nimitz>
	 <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Apr 2011 14:03:14 -0700
Message-ID: <1303160594.9887.309.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 13:25 -0700, David Rientjes wrote:
>  - provide a statically-allocated buffer to use for get_task_comm() and 
>    copy current->comm over before printing it, or
> 
>  - take task_lock(current) to protect against /proc/pid/comm.
> 
> The latter probably isn't safe because we could potentially already be 
> holding task_lock(current) during a GFP_ATOMIC page allocation. 

I'm not sure get_task_comm() is suitable, either.  It takes the task
lock:

char *get_task_comm(char *buf, struct task_struct *tsk)
{
        /* buf must be at least sizeof(tsk->comm) in size */
        task_lock(tsk);
        strncpy(buf, tsk->comm, sizeof(tsk->comm));
        task_unlock(tsk);
        return buf;
}

-- Dave

