Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1L1Klr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:41:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46178 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1L1Klo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:41:44 -0500
Date: Wed, 28 Dec 2011 14:41:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228104138.GI27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111227152344.c8c140d3.akpm@linux-foundation.org>
 <4EFAE5B9.8010109@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFAE5B9.8010109@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 01:47:37PM +0400, Pavel Emelyanov wrote:
> > A thought: if all we're trying to do here is to check for the sameness
> > of objects, can we push the comparison into the kernel so we don't have
> > this exporting-sensitive-info problem at all?  Just return a boolean to
> > userspace?
> > 
> > Something like
> > 
> > int sys_pid_fields_equal(pid_t pid1, pid_t pid2, enum pid_field field_id);
> > 
> > ?
> > 
> > For /proc/pid/fdinfo/* userspace can open /proc/pid1/fdinfo/0 and
> > /proc/pid2/fdinfo/0 and call sys_are_these_files_the_same(fd1, fd2, ...).
> > 
> > Perhaps sys_pid_fields_equal() can use sys_are_these_files_the_same()
> > as well, if we can think up a way of passing it two fds to represent
> > the two pids.
> > 
> > Have a think about it ;)
> 
> With this the complexity of determining sharing for N files scattered across
> several tasks would be N^2, since we'll have to compare each file to each file.
> 

Sigh. Indeed, I somehow missed that we have to compare a bunch of descriptors.

> On the other hand having just N IDs at hands would allow us to use more efficient
> algorithms resulting in e.g. N*log(N) complexity.
> 
> That said I'd really appreciate if we work out a solution with IDs.
> 

	Cyrill
