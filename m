Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0ECUml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:42:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:34047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0ECUmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:42:40 -0400
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <aruns@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com
In-Reply-To: <20100503203813.GA17886@sharma-home.net>
References: <20100503203813.GA17886@sharma-home.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 22:42:36 +0200
Message-ID: <1272919356.1642.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 13:38 -0700, Arun Sharma wrote:
> Enable PERF_SAMPLE_CPU by default. Implement --sort cpu.

Why? The downside is that you unconditionally grow each sample and thus
increase the overhead for something that doesn't make sense for the
normal (task-inherit) case.



