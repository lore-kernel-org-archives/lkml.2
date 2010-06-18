Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0FRHP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:15:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:37162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0FRHPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:15:55 -0400
Message-ID: <4C1B1CF5.9020900@kernel.org>
Date: Fri, 18 Jun 2010 09:15:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joel Becker <Joel.Becker@oracle.com>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<20100617161412.08337bc6.akpm@linux-foundation.org>	<20100617232502.GB7981@mail.oracle.com> <20100617165655.757d221a.akpm@linux-foundation.org>
In-Reply-To: <20100617165655.757d221a.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 07:15:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 01:56 AM, Andrew Morton wrote:
> On Thu, 17 Jun 2010 16:25:03 -0700
> Joel Becker <Joel.Becker@oracle.com> wrote:
> 
>> On Thu, Jun 17, 2010 at 04:14:12PM -0700, Andrew Morton wrote:
>>> flush_workqueue() sucks.  It's a stupid, accidental,
>>> internal-implementation-dependent interface.  We should deprecate it
>>> and try to get rid of it, migrating to the eminently more sensible
>>> flush_work().
>>>
>>> I guess the first step is to add a dont-do-that checkpatch warning when
>>> people try to add new flush_workqueue() calls.
>>>
>>> 165 instances tree-wide, sigh.
>>
>> 	What would the API be for "I want this workqueue emptied before
>> I shut this thing down?"
> 
> Um, yeah.  flush_workqueue() is legitimate.  I was thinking of
> flush_scheduled_work() - the one which operates on the keventd queue.

With cmwq, each wq now costs much less, so we should be able to
convert them to use their own workqueues without too much problem and
deprecate flushing of system workqueues.

Thanks.

-- 
tejun
