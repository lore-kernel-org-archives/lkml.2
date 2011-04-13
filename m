Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1DMVWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1DMVWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:22:19 -0400
Date: Wed, 13 Apr 2011 17:22:08 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Shaun Ruffell <sruffell@digium.com>, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
Message-ID: <20110413212208.GJ16939@redhat.com>
References: <20110406223036.GA15721@digium.com>
 <201104132133.51958.maciej.rutecki@gmail.com>
 <4DA6011F.7070405@openvz.org>
 <20110413203501.GA10744@digium.com>
 <4DA60B03.30603@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA60B03.30603@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 12:43:47AM +0400, Cyrill Gorcunov wrote:
> On 04/14/2011 12:35 AM, Shaun Ruffell wrote:
> ...
> > 
> > I had the first version of the patch running the test builds all night without
> > any NMIs. I installed this one and ran it through the case where I would
> > reliably get early NMIs and it still no NMIs.
> > 
> > So for v2:
> > Tested-by: Shaun Ruffell <sruffell@digium.com>
> > 
> > Thanks!
> 
> Thanks a huge Shaun. The thing is (if only I don't miss something) at moment there is
> no much difference in which patch to pick up. But as only kgdb dives in or any other
> subsystem (which say would use same manner of nmi delivery) we might be unmasking
> lvt entry even if nothing were handled at all, so I bias to a second version.

I agree with the second version.  Initially I wanted to enable it in the
case of the !handled path.  But your reasoning makes sense to me, don't
enable it in the !handled case because you might accidentally do something
bad.

Cheers,
Don
