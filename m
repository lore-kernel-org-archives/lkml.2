Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1DXRFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 13:05:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1DXRFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 13:05:45 -0400
Subject: Re: [PATCH] perf: Allow set output buffer for tasks in the same
 thread group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1303657064.2239.25.camel@localhost>
References: <1303657064.2239.25.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 24 Apr 2011 19:05:26 +0200
Message-ID: <1303664726.20212.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 22:57 +0800, Lin Ming wrote:
> Currently, kernel only allows an event to redirect its output to other
> events of the same task.
> 
> This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
> trying to redirect its output to other events in the same thread group.

Which is exactly what it should do, you should never be allowed to
redirect your events to that of another task, since that other task
might be running on another CPU.

The buffer code strictly assumes no concurrency, therefore its either
one task or one CPU.


