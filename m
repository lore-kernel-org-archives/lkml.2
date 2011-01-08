Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1AHL5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:57:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1AHL5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:57:30 -0500
Date: Sat, 8 Jan 2011 12:57:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hillf Danton <dhillf@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace ida in workqueue with page-sized buffer
Message-ID: <20110108115721.GB10971@elte.hu>
References: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
 <AANLkTinkxPSeWz1jev69quw+Nv+3JG0U6t2WE4cDkuxV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinkxPSeWz1jev69quw+Nv+3JG0U6t2WE4cDkuxV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hillf Danton <dhillf@gmail.com> wrote:

> On Sat, Dec 18, 2010 at 9:10 PM, Hillf Danton <dhillf@gmail.com> wrote:
> > The id of worker of global work queue is monitored with kernel library, ida.
> >
> > The ida in global work queue is redefined to be page-sized buffer,
> > which is allocated when initializing workqueue.
> >
> > The new id allocator could monitor ids in the rage from 0 to INT_MAX.
> > The buffer is used to store freed ids, and if the peak number of ids,
> > in workqueue as whole, is not out of the capacity of the allocated
> > buffer, there is no more allocation of buffer after initializing.
> >
> > The advantage looks that the new allocator runs faster.
> >
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Hey Ingo
> 
> Please take a glance at the patch for replacing ida in workqueue at
> 
>        https://lkml.org/lkml/2010/12/18/35
> 

Tejun is driving workqueues these days. (I've Cc:-ed him.)

Thanks,

	Ingo
