Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1GLM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:26:12 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:47683 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab1GLM0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:26:11 -0400
X-ASG-Debug-ID: 1310473570-01de280c1ebfaa0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1C3D5E.1050601@fusionio.com>
Date: Tue, 12 Jul 2011 14:26:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 0/3]CFQ: add think time check for service tree and
 group
References: <1310434672.15392.283.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH v2 0/3]CFQ: add think time check for service tree and
 group
In-Reply-To: <1310434672.15392.283.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310473570
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68703
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-12 03:37, Shaohua Li wrote:
> Hi,
>   Currently when the last queue of a service tree/group is empty, CFQ
> doesn't expire the queue. This is to allow requests from the tree/group
> come soon, so tree/group doesn't miss its share. But if the think time
> is big, the assumption isn't correct. idling the queue is just wasting
> bandwidth.
> 
> Originally I was hoping this can resolve Vivek's fsync issue, but it
> doesn't. The fsync issue is caused by queue idling. But since think time
> check only helps for think time above default queue idle time (8ms),
> think time check doesn't help for the fsync issue.
> 
> On the other hand, think time check is still helpful for queues with
> think time. I had test case in follow patches show throughput
> improvement without sacrifice tree/group shares.
> 
> v1->v2:
> 1. addressed some good comments from Vivek
> 2. add more test to make sure the patches don't change behavior of
> queues without think time.

I applied 1-3, thanks. 1 was hand applied, since it didn't apply
directly to for-3.1/core after I merged Justins patch to get rid of the
meta data request special treatment.

-- 
Jens Axboe

