Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1CGX7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:59:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab1CGX7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:59:14 -0500
Date: Mon, 7 Mar 2011 15:58:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pidns: Make pid_max per namespace
Message-Id: <20110307155823.22e47d73.akpm@linux-foundation.org>
In-Reply-To: <4D6F53B5.5090105@parallels.com>
References: <4D6F53B5.5090105@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Mar 2011 11:39:17 +0300
Pavel Emelyanov <xemul@parallels.com> wrote:

> Rationale:
> 
> On x86_64 with big ram people running containers set pid_max on host to 
> large values to be able to launch more containers. At the same time 
> containers running 32-bit software experience problems with large pids - ps
> calls readdir/stat on proc entries and inode's i_ino happen to be too big 
> for the 32-bit API.
> 
> Thus, the ability to limit the pid value inside container is required.
> 

This is a behavioural change, isn't it?  In current kernels a write to
/proc/sys/kernel/pid_max will change the max pid on all processes. 
After this change, that write will only affect processes in the current
namespace.  Anyone who was depending on the old behaviour might run
into problems?

Also: documentation.  Documentation/sysctl/kernel.txt would like an
update.  And perhaps also the pidns documentation which we forgot to
create :(


