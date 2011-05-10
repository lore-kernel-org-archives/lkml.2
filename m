Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1EJLEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:04:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1EJLED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:04:03 -0400
Subject: Re: [PATCH] wait: include linux/sched.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <20110510103628.GE2400@elte.hu>
References: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
	 <20110506075408.GI23166@elte.hu> <1305015103.2914.17.camel@laptop>
	 <20110510103628.GE2400@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 13:07:00 +0200
Message-ID: <1305025620.2914.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:36 +0200, Ingo Molnar wrote:
> 
> Obviously sched.h would include a lot of basic types to begin with, because it 
> is a fundamental 'container' type (struct task_struct) sitting at a top, 
> highlevel node of the type hierarchy - so the initial step you suggest would 
> indeed get us most of the benefits. 

I very well understand the whole header mess, and in particular last
time I looked at the sched.h vs wait.h thing simply removing the non
sched.c related things was enough to resolve this particular problem.

I really don't like the foo_type.h headers much and think we should only
use them as absolute last resort solutions.

I might have mis-read your email, but to me your:

  "To fix these super-headers like sched.h and to make wait.h
self-sufficient the right and cleanest approach would be to split data
types and primitive accessor functions.."

Seems to suggest to begin with that split, instead of starting with sane
cleanups like moving the signal and process (groups of tasks) bits out
into their own headers.



