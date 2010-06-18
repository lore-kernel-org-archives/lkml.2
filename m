Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0FRHQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:16:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:37200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0FRHQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:16:50 -0400
Message-ID: <4C1B1D3F.8030509@kernel.org>
Date: Fri, 18 Jun 2010 09:16:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost> <20100617161619.d3ebd73d.akpm@linux-foundation.org>
In-Reply-To: <20100617161619.d3ebd73d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 07:16:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 01:16 AM, Andrew Morton wrote:
> On Thu, 17 Jun 2010 08:01:06 -0400
> Andy Walls <awalls@md.metrocast.net> wrote:
> 
>> I'm going to agree with Tejun, that tweaking worker thread priorities
>> seems like an odd thing, since they are meant to handle deferable
>> actions - things that can be put off until later.
> 
> Disagree.  If you're in an interrupt handler and have some work which
> you want done in process context and you want it done RIGHT NOW then
> handing that work off to a realtime-policy worker thread is a fine way of
> doing that.

In that case, the right thing to do would be using threaded interrupt
handler.  It's not only easier but also provide enough context such
that RT kernel can do the right thing.

Thanks.

-- 
tejun
