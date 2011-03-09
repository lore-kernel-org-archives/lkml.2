Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1CIN4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:56:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab1CIN4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:56:21 -0500
Subject: Re: [PATCH 1/2] perf: Fix the software events state check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110309135252.GB1730@nowhere>
References: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
	 <20110309092818.GC25004@elte.hu>  <20110309135252.GB1730@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 14:55:59 +0100
Message-ID: <1299678959.2308.2989.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 14:52 +0100, Frederic Weisbecker wrote:
> 
> It seems that ->stop() / ->start() are called from perf_adjust_period()
> to update the hardware with the new settings of period_left. The events
> are stopped to avoid any race with events triggering with a stale period_left
> in the hardware level when the software one has been updated, I guess.
> 
> So it doesn't seem to fix any existing bug because for ->stop() and ->start()
> are only useful for hardware events right now. But we may call ->stop() and
> ->start() for further purpose later. In fact that paves the way for the event
> exclusion patchset I'm about to post.
> 
> So it should be .39 material. But a confirmation from Peter would be nice. 

Yeah, that sounds about right, I've already queued these patches
for .39.
