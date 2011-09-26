Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1IZHgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:36:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42714 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1IZHgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:36:50 -0400
Subject: Re: [PATCH 5/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Date: Mon, 26 Sep 2011 09:36:05 +0200
In-Reply-To: <CAOJsxLEHHJyPnCngQceRW04PLKFa3RUQEbc3rLwiOPXa7XZNeQ@mail.gmail.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-6-git-send-email-gilad@benyossef.com>
	 <CAOJsxLEHHJyPnCngQceRW04PLKFa3RUQEbc3rLwiOPXa7XZNeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317022565.9084.60.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 09:54 +0300, Pekka Enberg wrote:
> 
> AFAICT, flush_all() isn't all that performance sensitive. Why do we
> want to reduce IPIs here? 

Because it can wake up otherwise idle CPUs, wasting power. Or for the
case I care more about, unnecessarily perturb a CPU that didn't actually
have anything to flush but was running something, introducing jitter.

on_each_cpu() things are bad when you have a ton of CPUs (which is
pretty normal these days). 
