Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606Ab0FQSD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:03:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32129 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab0FQSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:03:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44745582"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Florian Mickler <florian@mickler.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <20100617072920.2b09912d@schatten.dmk.lab>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>
	 <4C191BE9.1060400@kernel.org> <4C192404.7000004@kernel.org>
	 <20100617072920.2b09912d@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 11:03:49 -0700
Message-ID: <1276797829.29614.42.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 07:29 +0200, Florian Mickler wrote:
>  
> 
> For what its worth, IMO the right thing to do would probably be to
> propagate the priority through the subsystem into the driver. 
> 
> Not fumbling with thread priorities. As Tejun said, these are not
> really userspace ABI ... (It's like hitting at the side of a vending
> machine if the coin is stuck... may work, but definitely not
> supported by the manufacturer) 

I don't agree with your analogy here .. It's more like you have two
items in the vending machine item A and item B. Tejun is saying he likes
item A, his friends like item A so that must mean item B is not
interesting so he removes it (without knowing how many people want it). 
So what happens? People use another vending machine. (Linux is the
vending machine) ..

>From my perspective this is like using Linux only for throughput which
is what Tejun is maximizing. In addition Tejun is blowing up the
alternative which is to prioritize the work items and sticking you with
strictly a throughput based system.

Do you thing maybe it's possible that the work items aren't all created
equal? Maybe one item _is_ more important than another one. Maybe on a
given system Tejun's workqueues runs a 1000 useless pointless work items
before he gets to the valuable one .. Yet the user is powerless to
dictate what is or is not important.

> Once you have the priority in the driver you could pass it to the
> workqueue subsystem (i.e. set the priority of the work) and the worker
> could then assume the priority of its work.
> 
> The tricky part is probably to pass the priority from the userspace
> thread to the kernel?

Threads are designed to have priorities tho, and threads are pervasive
throughout Linux .. It seems like setting a priorities to drivers would
be like re-inventing the wheel ..

If you were to say make the driver use kthreads instead of workqueues,
then you could set the priority of the kthreads .. However, you said
this isn't part of the ABI and so your back to your original argument
which is that you shouldn't be setting priorities in the first place.

Daniel

