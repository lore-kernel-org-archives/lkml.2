Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0GUPct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:32:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:57536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0GUPcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:32:46 -0400
Message-ID: <4C4712B4.9040706@kernel.org>
Date: Wed, 21 Jul 2010 17:31:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C470B46.4040604@kernel.org> <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com> <15189.1279725944@redhat.com>
In-Reply-To: <15189.1279725944@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 15:31:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 05:25 PM, David Howells wrote:
>> Each gcwq keeps track of currently running works in a hash table and looks
>> whether the work in question is already executing before starting executing
>> it.  It's a bit complex but as a work_struct may be freed once execution
>> starts, the status needs to be tracked outside.
> 
> Thanks, that's what I wanted to know.
> 
> I presume this survives an executing work_struct being freed, reallocated and
> requeued before the address of the work_struct is removed from the hash table?

It will unnecessarily stall the execution of the new work if the last
work is still running but nothing will be broken correctness-wise.

> I can see at least one way of doing this: marking the work_struct address in
> the hash when the address becomes pending again so that the process of hash
> removal will cause the work_struct to be requeued automatically.

If I'm correctly understanding what you're saying, the code already
does about the same thing.

Thanks.

-- 
tejun
