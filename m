Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0IBCQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:16:32 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:38094
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0IBCQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:16:31 -0400
Message-ID: <4C7F08ED.9010901@mit.edu>
Date: Wed, 01 Sep 2010 22:16:13 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Nicol <davidnicol@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is there a primitive to atomically release a spinlock and go
 to sleep?
References: <AANLkTimZnUEM6FFbgw==K3w6hURAgsAO8uRh5W1v6f_j@mail.gmail.com>
In-Reply-To: <AANLkTimZnUEM6FFbgw==K3w6hURAgsAO8uRh5W1v6f_j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Nicol wrote:
> I'm trying to do something involving multiple kthreads in an ioctl
> handler, and I want to avoid the
> race condition between the third and fourth steps of
> 
>     acquire mutex
>     add &self to a list of threads which will get awakened by
> something else that is also aware of this list
>     release mutex
>     go to sleep
> 
> Is there a standard atomic go-to-sleep function that takes as a
> parameter a pointer to  spinlock to release after its state is set to
> TASK_INTERRUPTIBLE?

That wouldn't be enough -- the other thread could try to wake you up before you're even in the list of threads.

Look at wait_event_*() or read this:

http://book.chinaunix.net/special/ebook/PrenticeHall/PrenticeHallPTRTheLinuxKernelPrimer/0131181637/ch03lev1sec7.html

--Andy
