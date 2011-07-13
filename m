Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1GMNsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:48:37 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:59259 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1GMNsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:48:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E1DA232.30408@cam.ac.uk>
Date: Wed, 13 Jul 2011 14:48:34 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
References: <4E1D6900.6040500@cam.ac.uk> <20110713133139.GO2872@htj.dyndns.org>
In-Reply-To: <20110713133139.GO2872@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/11 14:31, Tejun Heo wrote:
> (cc'ing Rusty Russell)
> Hello,
> 
> On Wed, Jul 13, 2011 at 10:44:32AM +0100, Jonathan Cameron wrote:
>> The other thing this highlights is that I suspect quite a few are protected by
>> spin locks when a mutex would be fine. Hence that might be worth tidying up first.
>>
>> Anyhow, a cleanup worth making? (obviously the exact form needs some work, but
>> I think the following is enough to start a discussion!)
>>
>> Subject: [PATCH] ida utility function
> 
> Rusty suggested similar addition some weeks ago, so people are really
> getting annoyed by this.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1148513/focus=74236
> 
> Here's an interface that I think should work,
> 
> 	int ida_get(struct ida *ida, int begin, int end, gfp_t gfp);
> 
> It uses an internal spinlock, returns the allocated ID and @end <= 0
> indicates no limit.
Cool.

Rusty, are you pursuing this?  Approach looks sensible to me.
