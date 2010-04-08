Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab0DHVMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:12:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab0DHVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:12:22 -0400
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
 perf_prepare_sample()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 23:12:19 +0200
Message-ID: <1270761139.20295.3159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
> 
> > There's various things that do indeed rely on the perf buffer to always
> > be u64 aligned, so this warning isn't bogus at all.
> >
> I assume this has to do with the wrap-around detection.

Nah, mostly dealing with architectures that don't do well with unaligned
accesses.

