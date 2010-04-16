Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0DPKx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:53:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:60034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab0DPKx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:53:27 -0400
Subject: Re: [PATCH v3] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1271206406-8575-1-git-send-regression-fweisbec@gmail.com>
References: <1271206406-8575-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Apr 2010 12:53:34 +0200
Message-ID: <1271415214.4807.1957.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 02:53 +0200, Frederic Weisbecker wrote:
> 
> Each time a software event triggers, we need to walk through
> the entire list of events from the current cpu and task contexts
> to retrieve a running perf event that matches.
> We also need to check a matching perf event is actually counting.
> 
> This walk is wasteful and makes the event fast path scaling
> down with a growing number of events running on the same
> contexts.
> 
> To solve this, we store the running perf events in a hashlist to
> get an immediate access to them against their type:event_id when
> they trigger. 

Looks good, thanks Frederic!
