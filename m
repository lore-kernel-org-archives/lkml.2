Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1L1Jrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:47:45 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:12184 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1L1Jrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:47:42 -0500
Message-ID: <4EFAE5B9.8010109@parallels.com>
Date: Wed, 28 Dec 2011 13:47:37 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
References: <20111223124741.711871189@openvz.org>	<20111223124920.661126615@openvz.org> <20111227152344.c8c140d3.akpm@linux-foundation.org>
In-Reply-To: <20111227152344.c8c140d3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A thought: if all we're trying to do here is to check for the sameness
> of objects, can we push the comparison into the kernel so we don't have
> this exporting-sensitive-info problem at all?  Just return a boolean to
> userspace?
> 
> Something like
> 
> int sys_pid_fields_equal(pid_t pid1, pid_t pid2, enum pid_field field_id);
> 
> ?
> 
> For /proc/pid/fdinfo/* userspace can open /proc/pid1/fdinfo/0 and
> /proc/pid2/fdinfo/0 and call sys_are_these_files_the_same(fd1, fd2, ...).
> 
> Perhaps sys_pid_fields_equal() can use sys_are_these_files_the_same()
> as well, if we can think up a way of passing it two fds to represent
> the two pids.
> 
> Have a think about it ;)

With this the complexity of determining sharing for N files scattered across
several tasks would be N^2, since we'll have to compare each file to each file.

On the other hand having just N IDs at hands would allow us to use more efficient
algorithms resulting in e.g. N*log(N) complexity.

That said I'd really appreciate if we work out a solution with IDs.

Thanks,
Pavel
