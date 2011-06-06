Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1FFQ3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:29:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52850 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1FFQ3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:29:52 -0400
Subject: Re: Change in functionality of futex() system call.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307377349.3098.65.camel@edumazet-laptop>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 18:29:42 +0200
Message-ID: <1307377782.2322.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:22 +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 18:16 +0200, Peter Zijlstra a écrit :
> 
> > Hmm, wouldn't that still be susceptible to the zero-page thing if: we
> > create a writable private file map of a sparse file, touch a page and
> > then remap the thing RO?
> > 
> > 
> > 
> 
> Also I am not sure how MAP_PRIVATE could be affected. If we still try a
> RW gup()... It will allocate a page for us, instead of still pointing to
> shared one.
> 
> On previous kernel, the application using read-only mapping could use
> MAP_PRIVATE or MAP_SHARED with same 'behavior'

But by not forcing the COW you get different behaviour depending on when
you call FUTEX_WAIT, surely that's not correct either?
