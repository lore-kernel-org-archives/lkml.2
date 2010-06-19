Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0FSJoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:44:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab0FSJoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:44:08 -0400
Message-ID: <4C1C911B.6040601@kernel.org>
Date: Sat, 19 Jun 2010 11:42:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276697146.9309.27.camel@m0nster> <1276776066.2461.15.camel@localhost> <87vd9fo1sk.fsf@basil.nowhere.org> <4C1C8263.9040404@kernel.org> <87fx0jo0z6.fsf@basil.nowhere.org> <4C1C8772.8090406@kernel.org> <20100619090851.GF18946@basil.fritz.box> <4C1C8A18.2030709@kernel.org> <20100619091518.GG18946@basil.fritz.box> <4C1C8B32.1040007@kernel.org> <20100619092758.GH18946@basil.fritz.box>
In-Reply-To: <20100619092758.GH18946@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 09:42:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/19/2010 11:27 AM, Andi Kleen wrote:
>> Can you think of anything else which could benefit from high priority
>> queueing?
> 
> Over time we'll get more error handling, e.g. advanced NMI handling.
> Maybe it could be useful for thermal handling too which is a similar
> situation.
> 
> To be honest I would prefer if there aren't that many more users,
> the more users the less useful it becomes.

As long as the actual frequency is low, the number of users should be
okay.  Okay, just one more question before adding it to todo list.  Do
you think it would really benefit from scalability provided by
multiple workers?

* Do machines ever report that many MCE errors?  The usual rate seems
  like one per weeks or months even when they're frequent.

* If a machine is actually reporting enough errors to overwhelm single
  error handling thread, does it even matter what we do?

Thanks.

-- 
tejun
