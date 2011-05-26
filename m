Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1EZIur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab1EZIup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:50:45 -0400
Message-ID: <4DDE1419.3000708@redhat.com>
Date: Thu, 26 May 2011 11:49:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu>
In-Reply-To: <20110526082451.GB26775@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 11:24 AM, Ingo Molnar wrote:
> So a simple object manager would simply use file label event
> attributes and would define simple rules like:
>
> 	"(label&  tmp_t) || (label&  user_home_t)"

Filtering by label vs. filtering by descriptor would solve qemu's 
hotplug issue neatly.

> Note that tools/kvm/ would probably like to implement its own object
> manager model as well in addition to access method restrictions: by
> being virtual hardware it deals with many resources and object
> hierarchies that are simply not known to the host OS's LSM.
>
> Unlike Qemu tools/kvm/ has a design that is very fit for MAC
> concepts: it uses separate helper threads for separate resources
> (this could in many cases even be changed to be separate processes
> which only share access to the guest RAM image) - while Qemu is in
> most parts a state machine, so in tools/kvm/ we can realistically
> have a good object manager and keep an exploit in a networking
> interface driver from being able to access disk driver state.

You mean each thread will have a different security context?  I don't 
see the point.  All threads share all of memory so it would be trivial 
for one thread to exploit another and gain all of its privileges.

A multi process model works better but it has significant memory and 
performance overhead.

(well the memory overhead is much smaller when using transparent huge 
pages, but these only work for anonymous memory).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

