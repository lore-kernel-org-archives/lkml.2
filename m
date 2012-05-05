Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab2EESXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:23:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:41802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab2EESXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:23:00 -0400
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 May 2012 20:22:47 +0200
Message-ID: <1336242167.2463.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-06 at 00:23 +0900, Namhyung Kim wrote:
> +       static struct callchain_cursor cursor;

This just begs to become another concurrency problem. If anybody manages
to call multiple hists__collapse_insert_entry() concurrently you're
again up some creek without no paddle.

Adding global state is never a good option when dealing with
concurrency.

