Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0KIM02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:26:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54437 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755167Ab0KIM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:26:27 -0500
Date: Tue, 9 Nov 2010 12:24:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: David Rientjes <rientjes@google.com>, figo zhang <figo1802@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
Message-ID: <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20101109195726.BC9E.A69D9226@jp.fujitsu.com>
References: <1288834737.2124.11.camel@myhost>
	<alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com>
	<20101109195726.BC9E.A69D9226@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > process with CAP_SYS_RESOURCE capibility which have system resource
> > > limits, like journaling resource on ext3/4 filesystem, RTC clock. so it
> > > also the same treatment as process with CAP_SYS_ADMIN.
> > > 
> > 
> > NACK, there's no justification that these tasks should be given a 3% 
> > memory bonus in the oom killer heuristic; in fact, since they can allocate 
> > without limits it is more important to target these tasks if they are 
> > using an egregious amount of memory.
> 
> David, Stupid are YOU. you removed CAP_SYS_RESOURCE condition with ZERO
> explanation and Figo reported a regression. That's enough the reason to
> undo. YOU have a guilty to explain why do you want to change and why
> do you think it has justification.
> 
> Don't blame bug reporter. That's completely wrong.

Can people stop throwing things at each other and worry about the facts

- If it's a regression it should get reverted or fixed. But is it
  actually a regression ? Has the underlying behaviour changed in a
  problematic way?

"CAP_SYS_RESOURCE threads have the ability to lower their own oom_score_adj
 values, thus, they should protect themselves if necessary like
 everything else."

The reverse can be argued equally - that they can unprotect themselves if
necessary. In fact it seems to be a "point of view" sort of question
which way you deal with CAP_SYS_RESOURCE, and that to me argues that
changing from old expected behaviour to a new behaviour is a regression.



