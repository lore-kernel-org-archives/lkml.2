Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DTO6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab1DTO6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:58:11 -0400
Date: Wed, 20 Apr 2011 10:57:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, nmi: Move LVT un-masking into irq handlers
Message-ID: <20110420145754.GT20887@redhat.com>
References: <1303145815-15050-1-git-send-email-dzickus@redhat.com>
 <4DAEEF96.4070807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAEEF96.4070807@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 06:37:10PM +0400, Cyrill Gorcunov wrote:
> Don, sorry for delay, I somehow missed this patch at first place :/ And probably
> the patch below could help with "stess" problem?

The patch I am using for the 'stress' problem is different than what I
posted because I wanted to keep it simple for 2.6.39.  But yeah I already
moved the unmasking to the enable_pmus_all(0) line.

The thing is that cuts down on some of these in-flight NMIs but not all of
them.  I came up with some logic that catches all the in-flight NMIs on
Nehalem and AMDs but my core2quad still fails.  I'll try to post that
today while requesting help.

Still not sure you need the double APIC writes (as your patch) shows.  I
haven't seen a case in my testing where a single APIC write fails.

Cheers,
Don
