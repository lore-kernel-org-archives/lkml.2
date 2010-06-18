Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0FRIXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:23:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:54988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab0FRIXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:23:49 -0400
Message-ID: <4C1B2CE0.3040400@kernel.org>
Date: Fri, 18 Jun 2010 10:22:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<4C18DC69.10704@kernel.org>	<1276698880.9309.44.camel@m0nster>	<4C18E4B7.5040702@kernel.org>	<1276701074.9309.60.camel@m0nster>	<4C18F2B8.9060805@kernel.org>	<1276705838.9309.94.camel@m0nster>	<4C1901E9.2080907@kernel.org> <20100617161539.d4ea62c0.akpm@linux-foundation.org> <4C1B2864.6010305@kernel.org>
In-Reply-To: <4C1B2864.6010305@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 08:22:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 10:03 AM, Tejun Heo wrote:
> Converting to kthread is usually okay to do but getting the
> kthread_stop() and memory barriers right can be pain in the ass, so
> having a easier wrapper there would be pretty helpful.

Thinking more about it the interface could be pretty similar to wq.
The only qualm I have w/ wq is that it requires allowing works to be
freed once execution starts, which is sometimes convenient but a major
pain to implement correctly w/ flushing, requeueing and all.  Such
complexities end up visible to the users too through quirkiness in
flush semantics.  But, other than that, wrapping kthread in a prettier
outfit for cases which require a dedicated thread and don't wanna
bother with kthread directly should only take few hundred lines of
code.

Thanks.

-- 
tejun
