Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2EBSjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:39:44 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:58248 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:39:43 -0400
Message-ID: <4FA17F6A.9000606@genband.com>
Date: Wed, 02 May 2012 12:39:38 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: George Porter <gmporter@cs.ucsd.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: read() syscall slowing down due to other threads?
References: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
In-Reply-To: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2012 18:39:39.0002 (UTC) FILETIME=[EE2F35A0:01CD2892]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18880.001
X-TM-AS-Result: No--5.441000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 12:03 AM, George Porter wrote:

> However, if I start doing more computation on those other threads, the
> read() syscalls take longer to read the same amount of data,
> eventually slowing down to 50 MBps (50% slower).  I've used
> setaffinity() to isolate the Reader threads to one set of cores, and
> the compute threads to a different set of cores, and so I don't think
> it is CPU/scheduling interference.
>
> Thoughts?  Has anyone run into this before?

If you're using hyperthreading you may want to try it with either 
putting the computation threads on the siblings of the cpus for the 
reader threads (to share cache) or else not on the siblings of the cpus 
for the reader threads (to minimize contention of cpu resources).

Similarly, you may want to play with wither or not the threads are on 
the same or different sockets.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
