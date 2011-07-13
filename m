Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1GMUrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:47:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1GMUrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:47:47 -0400
Subject: Re: [PATCH 3/6] sched: Avoid redundant initialization of runqueues
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1310580816-10861-4-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-4-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 22:47:43 +0200
Message-ID: <1310590063.2586.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
> Within sched_init() the functions init_{cfs,rt}_rq() are called
> unconditionally. However, when group scheduling is enabled, those calls
> are also done in init_tg_{cfs,rt}_entry().
> 
> To avoid this redundant initialization, the direct calls within
> sched_init() to init_{cfs,rt}_rq() are dropped in case of enabled group
> scheduling.

But it adds #ifdef muck.. 

