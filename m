Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0KOK7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:59:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51834 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967Ab0KOK7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:59:38 -0500
Date: Mon, 15 Nov 2010 10:57:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101115105735.0f9c1a22@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1011150204060.2986@chino.kir.corp.google.com>
References: <1289402093.10699.25.camel@localhost.localdomain>
	<1289402666.10699.28.camel@localhost.localdomain>
	<20101114141913.E019.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011141330120.22262@chino.kir.corp.google.com>
	<4CE0A87E.1030304@leadcoretech.com>
	<alpine.DEB.2.00.1011150204060.2986@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The goal was to make the oom killer heuristic as predictable as possible 
> and to kill the most memory-hogging task to avoid having to recall it and 
> needlessly kill several tasks.

Meta question - why is that a good thing. In a desktop environment it's
frequently wrong, in a server environment it is often wrong. We had this
before where people spend months fiddling with the vm and make it work
slightly differently and it suits their workload, then other workloads go
downhill. Then the cycle repeats.

> You have full control over disabling a task from being considered with 
> oom_score_adj just like you did with oom_adj.  Since oom_adj is 
> deprecated for two years, you can even use the old interface until then.

Which changeset added it to the Documentation directory as deprecated ?

Alan
