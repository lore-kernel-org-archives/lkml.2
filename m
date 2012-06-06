Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2FFOix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:38:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:37783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2FFOiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:38:52 -0400
Message-ID: <1338993524.2749.122.camel@twins>
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 16:38:44 +0200
In-Reply-To: <CABPqkBQ7xwK+BjYainpxXV+D_KjMgH0KFVhYK9w89TxqQOF_MQ@mail.gmail.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
	 <1338979579.2749.95.camel@twins>
	 <20120606141644.GF28225@tassilo.jf.intel.com>
	 <1338992472.2749.116.camel@twins>
	 <CABPqkBQ7xwK+BjYainpxXV+D_KjMgH0KFVhYK9w89TxqQOF_MQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 16:33 +0200, Stephane Eranian wrote:
> Yes, his patch did but somehow I don't see this code in tip-x86.
> The thing that I would worry about between rdmsrl() and rdpmc()
> is what happens to the upper bits. rdpmc() returns bits [N-1:0] of
> the N-bit counters. N is 48 (or 40) nowadays. When you read 64 bit
> worth, what do you get in bits [63:N]? are those sign-extended or
> zero-extended. Is that the same behavior across all Intel and AMD
> processors? With perf_events, I think the (N-1)th bit is always set.
> 
Queued his patch after I saw Andi's trainwreck -- had totally forgotten
about it :/

For the kernel it doesn't matter, we manually sign-extend for however
many bits the counter has.
