Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0CRTE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:04:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:37763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CRTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:04:28 -0400
Subject: Re: [PATCH] perf_events: fix ordering bug in perf_output_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4ba2317a.8109cc0a.2858.ffffcd0c@mx.google.com>
References: <4ba2317a.8109cc0a.2858.ffffcd0c@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 19:33:14 +0100
Message-ID: <1268937194.9440.373.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 14:42 +0200, Stephane Eranian wrote:
> 	In order to parse a sample correctly based on the information
> 	requested via sample_type, the kernel needs to save each component
> 	in a known order. There is no type value saved with each component.
> 	The current convention is that each component is saved according to
> 	the order in enum perf_event_sample_format. But perf_output_sample()
> 	was not completely following this convention, thereby making samples
> 	impossible to parse without internal kernel knowledge.
> 
> 	This patch puts things in the right order.

NAK, not so actually, its in the order specified in the
PERF_RECORD_SAMPLE comment.

