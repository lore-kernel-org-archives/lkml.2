Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2FTKQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:16:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2FTKQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:16:18 -0400
Message-ID: <1340187373.21745.95.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 12:16:13 +0200
In-Reply-To: <20120620100031.GI1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	 <20120620092932.GH1478@erda.amd.com> <1340185084.21745.81.camel@twins>
	 <20120620100031.GI1478@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 12:00 +0200, Robert Richter wrote:
> 
> And wrt counter rotation, this only affects code to assign counters.
> You don't need a separate pmu for this. 

It makes it easier though, on unplug you would otherwise need to filter
what events are uncore and migrate those to another online cpu of the
same nb instead of all events..

Also, what cpu on the NB receives the PMI?

Sure it can be done, just not pretty. Combine that with all the other
special casing like patches 3 and 10 and one really starts to wonder if
its all worth it.


