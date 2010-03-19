Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0CSAOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:14:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:55065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0CSAOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:14:47 -0400
Subject: Re: [PATCH] perf_events: fix ordering bug in perf_output_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901003181429j235ac282pe0440f02b9138015@mail.gmail.com>
References: <4ba2317a.8109cc0a.2858.ffffcd0c@mx.google.com>
	 <1268937194.9440.373.camel@laptop>
	 <bd4cb8901003181429j235ac282pe0440f02b9138015@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 01:14:40 +0100
Message-ID: <1268957680.9440.430.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 22:29 +0100, Stephane Eranian wrote:
> On Thu, Mar 18, 2010 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2010-03-18 at 14:42 +0200, Stephane Eranian wrote:
> >>       In order to parse a sample correctly based on the information
> >>       requested via sample_type, the kernel needs to save each component
> >>       in a known order. There is no type value saved with each component.
> >>       The current convention is that each component is saved according to
> >>       the order in enum perf_event_sample_format. But perf_output_sample()
> >>       was not completely following this convention, thereby making samples
> >>       impossible to parse without internal kernel knowledge.
> >>
> >>       This patch puts things in the right order.
> >
> > NAK, not so actually, its in the order specified in the
> > PERF_RECORD_SAMPLE comment.
> >
> And why is that order different than the one in the enum?

Because I tried to keep the simple elements before the complex ones, but
in any case its too late to change any ordering there now, as its ABI.

