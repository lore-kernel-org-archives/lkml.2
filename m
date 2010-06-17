Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab0FQMEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:04:52 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:11035 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759860Ab0FQMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:04:51 -0400
Subject: Re: Overview of concurrency managed workqueue
From: Andy Walls <awalls@md.metrocast.net>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <1276697146.9309.27.camel@m0nster>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org>  <1276697146.9309.27.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 08:01:06 -0400
Message-ID: <1276776066.2461.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-06-17_02:2010-02-06,2010-06-17,2010-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1006170039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 07:05 -0700, Daniel Walker wrote:
> On Wed, 2010-06-16 at 15:45 +0200, Tejun Heo wrote:
> > On 06/16/2010 03:41 PM, Daniel Walker wrote:
> > > Any workqueue that has a thread which can be prioritized from userspace.
> > > As long as there is a thread it can usually be given a priority from
> > > userspace, so any _current_ workqueue which uses a single thread or
> > > multiple threads is an example of what I'm talking about.
> > 
> > Eh... what's the use case for that?  That's just so wrong.  What do
> > you do after a suspend/resume cycle?  Reprioritize all of them from
> > suspend/resume hooks?
> 
> The use case is any situation when the user wants to give higher
> priority to some set of work items, and there's nothing wrong with that.
> In fact there has been a lot of work in the RT kernel related to
> workqueue prioritization ..

I'm going to agree with Tejun, that tweaking worker thread priorities
seems like an odd thing, since they are meant to handle deferable
actions - things that can be put off until later.

If one needs to support Real Time deadlines on deferable actions,
wouldn't using dedicated kernel threads be more deterministic?
Would the user ever up the priority for a workqueue other than a
single-threaded workqueue?

Regards,
Andy

> Daniel



