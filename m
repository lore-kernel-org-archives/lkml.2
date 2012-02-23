Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2BWJJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:09:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35221 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2BWJJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:09:11 -0500
Message-ID: <1329988135.24994.43.camel@twins>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 23 Feb 2012 10:08:55 +0100
In-Reply-To: <20120223075027.GB15306@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	 <20120223075027.GB15306@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 08:50 +0100, Ingo Molnar wrote:
> * Venkatesh Pallipadi <venki@google.com> wrote:

> > * We can also eliminate TS_POLLING flag in favor of this. But, that will have
> >   a lot more touchpoints and better done as a standlone change.
> 
> Should most definitely be done for this series to be acceptble - 
> as a preparatory patch in the series, with the feature at the 
> end of the series.

I don't think you can, TS_POLLING still works for idle=poll, whereas
this new stuff requires monitor/mwait.

