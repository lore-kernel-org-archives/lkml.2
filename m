Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab2C2Srp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:47:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35424 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2C2Srk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:47:40 -0400
Date: Thu, 29 Mar 2012 19:50:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329195007.07d53db7@pyramind.ukuu.org.uk>
In-Reply-To: <20120329175209.GE16476@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
	<20120329145055.GE13912@fifo99.com>
	<4F748CF6.4010205@am.sony.com>
	<20120329175209.GE16476@fifo99.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 10:52:10 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> On Thu, Mar 29, 2012 at 09:25:26AM -0700, Tim Bird wrote:
> > At the moment, I'm not considering an alternative for logger that runs
> > completely in user-space.  Having said that, this test is certainly interesting,
> > and may provide some performance numbers for logger or alternatives that would
> > be useful to compare.
> 
> 
> I was just thinking what does an accurate PID actually get you? If you
> looking at some logs with a PID of 20048, does that mean something to
> you? It doesn't actually mean much because you can't map that back to
> anything. If you have the device, and the process is still running then
> you could look it up ..
> 
> So lets say logger was modified to record comm values.. That way you
> could record the actual process name AND the pid. Well if you use
> prctl(PR_SET_NAME), you can forge comm values. So that doesn't get you
> much either..
> 
> So even if you record accurate PID values, it doesn't mean anything
> anyway.

The question is whether you are trying to record data for analysis in a
hostile environment or you are trying to do useful debugging. If your
apps are non hostile then PR_SET_NAME is actually useful in logging to
split apart different executions of the same daemon.

The Android logger has no security model of any real kind so it's clearly
about the debug side. In that case the PID lets you correlate with other
logs, the comm data might be useful.

Alan
