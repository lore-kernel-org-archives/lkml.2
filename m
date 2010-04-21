Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DUMKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:10:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0DUMKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:10:33 -0400
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100415151633.GN11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271317461.32749.67.camel@laptop>  <20100415151633.GN11907@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 21 Apr 2010 14:11:05 +0200
Message-ID: <1271851865.4807.10284.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 17:16 +0200, Robert Richter wrote:
> On 15.04.10 09:44:21, Peter Zijlstra wrote:
> > On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
> > > This patch series introduces model specific events and impments AMD
> > > IBS (Instruction Based Sampling) for perf_events.
> > 
> > I would much rather it uses the ->precise thing PEBS also uses,
> > otherwise we keep growing funny arch extensions and end up with a
> > totally fragmented trainwreck of an ABI.
> 
> I agree that an exiting flag could be reused. But the naming 'precise'
> could be misleading. Maybe we rename it to 'model_spec' or something
> else that underlines the idea of having model specific setups.

Right, so I really hate PERF_SAMPLE_RAW, and I'm considering simply
removing that for PEBS as well, its just too ugly. If we want the
register set we need to work on getting PERF_SAMPLE_REGS in a sensible
shape.

As to the meaning for ->precise, its meant to convey the counters are
not affected by skid and the like, I thought IBS provided exact IPs as
well (/me should re-read the IBS docs).

The thing with something like ->model_spec and PERF_SAMPLE_RAW is that
it doesn't provide a clear model, the user doesn't know what to expect
of it, it could be anything.

We want the ABI to express clear concepts, and things like lets bypass
everything and just dump stuff out to userspace really are to be avoided
at all costs.

Sadly IBS seems to be an utter trainwreck in the concept department (I'm
still struggling how to make a sensible interpretation of the data it
gathers).

The thing I absolutely want to avoid is the ABI becoming a fragmented
trainwreck like oprofile is.

Also not using sample_period for the sample period is of course utterly
unacceptable.
