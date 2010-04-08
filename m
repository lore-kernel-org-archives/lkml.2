Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab0DHUzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:55:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:39244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab0DHUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:55:40 -0400
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in
 perf_prepare_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 22:55:36 +0200
Message-ID: <1270760136.20295.3121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 22:45 +0200, Stephane Eranian wrote:
> 	There is a warn_on_once() check for PERF_SAMPLE_RAW which trips
> 	when using PEBS on both Core and Nehalem. Core PEBS sample size is 144
> 	bytes and 176 bytes for Nehalem. Both are multiples of 8, but the size
> 	field is encoded as int, thus the total is never a multiple of 8 which
> 	trips the check. I think the size should have been u64, but now it is
> 	too late to change given it is ABI.

PEBS hasn't seen -linus yet, so we can fix that.

There's various things that do indeed rely on the perf buffer to always
be u64 aligned, so this warning isn't bogus at all.

