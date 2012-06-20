Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2FTJiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:38:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:55054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2FTJiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:38:09 -0400
Message-ID: <1340185084.21745.81.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 11:38:04 +0200
In-Reply-To: <20120620092932.GH1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	 <20120620092932.GH1478@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 11:29 +0200, Robert Richter wrote:
> Second, since nb perfctr are implemented the same way as core
> counters, the same code would have been used. Thus multiple (two) x86
> pmus (struct x86_pmu) would reside in parallel in the kernel. 

Well, no. The I take it the uncore counters are nb wide, thus you need
special goo to make counter rotation work properly, x86_pmu is unsuited
for that.


