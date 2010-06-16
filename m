Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab0FPOxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:53:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:38248 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0FPOw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:52:59 -0400
Subject: Re: [RFC] perf/perf_events: misleading number of samples due to
 mmap()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
References: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 16:52:42 +0200
Message-ID: <1276699962.1745.599.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 16:40 +0200, Stephane Eranian wrote:
> This leads me to another point. For per-thread sampling, why
> do we need to record mmap() events happening *outside* of
> the process? I can understand the exception of kernel modules. 

How does that happen? The per-thread events should be on the per-task
context, so another task's mmap() events should never end up there.
