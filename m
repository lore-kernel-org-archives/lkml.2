Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1HYRc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:32:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:44975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1HYRcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:32:55 -0400
Subject: Re: [BUG] perf_event: semantic of PERF_SAMPLE_READ unclear
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Date: Thu, 25 Aug 2011 19:32:40 +0200
In-Reply-To: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314293560.27911.38.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 19:19 +0200, Stephane Eranian wrote:
> But the difficulty is that
> we cannot grab any locks, not sure we need one given the call path. 

Nah we should be able to simply iterate all siblings and update them
in-place, since its group members they should all be co-scheduled. The
only difficulty is cross pmu group members.. 
