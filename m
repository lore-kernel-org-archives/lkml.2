Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1EKVEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:04:51 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46230 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab1EKVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:04:50 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: John Stultz <john.stultz@linaro.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <m2sjsli1ft.fsf@firstfloor.org>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <m2sjsli1ft.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 14:04:27 -0700
Message-ID: <1305147867.2883.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 10:36 -0700, Andi Kleen wrote:
> John Stultz <john.stultz@linaro.org> writes:
> 
> > Acessing task->comm requires proper locking. However in the past
> > access to current->comm could be done without locking. This
> > is no longer the case, so all comm access needs to be done
> > while holding the comm_lock.
> >
> > In my attempt to clean up unprotected comm access, I've noticed
> > most comm access is done for printk output. To simpify correct
> > locking in these cases, I've introduced a new %ptc format,
> > which will safely print the corresponding task's comm.
> >
> > Example use:
> > printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> 
> Neat. But you probably want a checkpatch rule for this too
> to catch new offenders.

Yea. That's on my queue.

thanks
-john


