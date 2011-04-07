Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab1DGARK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:17:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1DGARJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:17:09 -0400
Date: Wed, 6 Apr 2011 20:16:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Shaun Ruffell <sruffell@digium.com>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
Message-ID: <20110407001658.GW12642@redhat.com>
References: <20110406223036.GA15721@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406223036.GA15721@digium.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 05:30:36PM -0500, Shaun Ruffell wrote:
> Hello Don,
> 
> I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
> certain where to go from here.  Is this something that is already known
> or is there more information I should try to collect? 

Nope, this is an ongoing issue.  What happened was the perf P4 nmi handler
was swallowing all the NMIs.  My patch fixed that and exposed a double NMI
problem.  We have been chasing it for a couple of months.  I think Cyril
was finally able to duplicate it (as he wrote the P4 code).  I have
confidence that he will find a fix for it soon. :-)

Thanks for the report though!

Cheers,
Don
