Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2CGU7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:59:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2CGU7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:59:41 -0500
Message-ID: <1331153964.11248.362.camel@twins>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org, dsahern@gmail.com,
        fweisbec@gmail.com, yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Date: Wed, 07 Mar 2012 21:59:24 +0100
In-Reply-To: <20120307203725.GA4333@elte.hu>
References: <20120307114249.44275ca3@kryten>
	 <20120307010904.GE5656@infradead.org> <20120306192912.59811e3e@wrlaptop>
	 <20120307203725.GA4333@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 21:37 +0100, Ingo Molnar wrote:
>         size_needed = snprintf_size(...);

This would require 3 passes over the fmt+args, first to find the
allocated size is insufficient, 2nd to compute the size, 3rd to fill
buffer.

Whereas with the current "creative" API only 2 passes are needed.

I can imagine that back in the day of small memory and small CPU this
was deemed important enough.

Anyway, its all moot, this API exists and has been out in the wild for
several decades now, its not like we can actually change it :-)
