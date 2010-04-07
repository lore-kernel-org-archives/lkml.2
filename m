Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0DGL60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:58:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0DGL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:58:23 -0400
Subject: Re: [PATCH] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100407115624.GD5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
	 <1270567653.20295.11.camel@laptop>  <20100407115624.GD5143@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 13:58:20 +0200
Message-ID: <1270641500.20295.807.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 13:56 +0200, Frederic Weisbecker wrote:
> 
> > 
> > So looks good, altough I think we want to do that online/hotplug thing.
> 
> 
> That would let us allocate on online cpus instead of possibles? Yeah right.

Right, so if you want to go this route (and not simply embed it in the
percpu data), the complication I thought of is that you want the
refcount on offline cpus but not the allocation, since its very hard to
reconstruct the number of events that had event->cpu == -1.

