Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab2EIILy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:11:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:60812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2EIILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:11:51 -0400
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
From: Peter Zijlstra <peterz@infradead.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
	 <1336514192.8226.52.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
	 <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 May 2012 10:11:39 +0200
Message-ID: <1336551100.27020.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 15:46 -0700, Diwakar Tundlam wrote:
> Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
> An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
> As seen in my output of sched_debug.

Ah, quite possible. %Ld is indeed %lld and the value is long, not long
long. So the proper fix is to fudge that printk statement somehow.

> Your machine is probably natively 64-bit. 

Yeah, I gave up on 32bit computing a while ago..

