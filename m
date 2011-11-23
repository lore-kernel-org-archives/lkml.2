Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1KWKgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:36:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46335 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1KWKgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:36:53 -0500
Message-ID: <1322044606.14799.26.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
 sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Wed, 23 Nov 2011 11:36:46 +0100
In-Reply-To: <CABPqkBRE6bH8WV1ZMeUKrEuF3D4M8WymxzkZOOjsnbya-cOSYg@mail.gmail.com>
References: <20111116145320.GA20146@quad> <1321958457.5148.17.camel@twins>
	 <CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
	 <1321968559.14799.2.camel@twins>
	 <CABPqkBTWqPNhMBEsLmto+3=2FYjyy_b2hzq2KLbKWDFSKNktsg@mail.gmail.com>
	 <1322042767.14799.25.camel@twins>
	 <CABPqkBRE6bH8WV1ZMeUKrEuF3D4M8WymxzkZOOjsnbya-cOSYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 11:10 +0100, Stephane Eranian wrote:
> On Wed, Nov 23, 2011 at 11:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-11-23 at 10:30 +0100, Stephane Eranian wrote:
> >>
> >> In the case of perf_event, we are not in a producer-consumer model, so
> >> it seems like the behavior we have now is correct. The caller of poll()
> >> gets stuck if the file descriptor is closed.
> >
> > But wouldn't out event->waitq still be referenced by that waiting task?
> > Even though we freed it in our fops->release() callback?
> >
> I suspect you don't end up in fops->release() if you have an ongoing poll
> because you've probably increment the file's refcount along the way.

You're quite right, poll does that internally. Ok, so we don't need to
worry about this bit then.
