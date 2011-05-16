Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1EPLIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:08:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:41688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab1EPLH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:07:59 -0400
Subject: Re: [patch 07/15] sched: expire invalid runtime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110503092905.075386331@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092905.075386331@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 13:07:41 +0200
Message-ID: <1305544061.2466.4157.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> With the global quota pool, one challenge is determining when the runtime we
> have received from it is still valid.  Fortunately we can take advantage of
> sched_clock synchronization around the jiffy to do this cheaply.
> 
> The one catch is that we don't know whether our local clock is behind or ahead
> of the cpu setting the expiration time (relative to its own clock).
> 
> Fortunately we can detect which of these is the case by determining whether the
> global deadline has advanced.  If it has not, then we assume we are behind, and
> advance our local expiration; otherwise, we know the deadline has truly passed
> and we expire our local runtime.

This needs a few words explaining why we need to do all this. It only e
explains the how of it.
