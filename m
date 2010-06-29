Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0F2QLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:11:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0F2QLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:11:33 -0400
Message-ID: <4C2A1ABF.8050504@kernel.org>
Date: Tue, 29 Jun 2010 18:09:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29A33D.2060407@kernel.org> <20100629123632.GB5318@nowhere> <4C2A145E.8030608@kernel.org> <20100629154738.GJ5318@nowhere> <4C2A1672.20700@kernel.org> <20100629160100.GL5318@nowhere>
In-Reply-To: <20100629160100.GL5318@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 16:09:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 06:01 PM, Frederic Weisbecker wrote:
> So, imagine you allocate your struct with alloc_percpu(align).
> 
> The per cpu pointer is 0x400 (purely imagination).
> 
> Now you have two cpus and they have the following base offsets for
> per cpu allocations:
> 
> CPU 0 = 0xf1000000
> CPU 1 = 0xf2000000
> 
> So, the true pointers for your cpu workqueue structs will be:
> 
> CPU 0 = 0xf1000400
> CPU 1 = 0xf2000400
> 
> These addresses are aligned like you wanted to, and it seems it is what
> matters, to store these addresses in the work flags.

Yes.

> So why does the size of the struct need to be aligned too?

Where am I doing that?

> All you want is that the two above addresses are aligned. Now why
> the size of the struct itself needs this alignment too. That's the
> obscure point for me. If it's useless, this could avoid all this
> alignment maintainance, except during the allocation itself.

What alignment maintenance?  Are you talking about the UP code?  If
you're talking about the UP code, the ugliness there is because the
current UP __alloc_percpu() can't honor the alignment parameter.

Heh, it seems I'm still lost.  Care to give one more shot at it?  :-)

Thanks.

-- 
tejun
