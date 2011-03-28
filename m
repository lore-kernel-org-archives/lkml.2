Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1C1WRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:17:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56123 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754916Ab1C1WRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:17:50 -0400
Date: Mon, 28 Mar 2011 23:18:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110328231818.2297408f@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
	<20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
	<20110328180655.GI2287@linux.vnet.ibm.com>
	<AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  ok - well, having thought about this a little bit (in a non-detailed
> high-level way) i was sort-of hoping, as alan hinted at, to still do
> SMP, even if it's slow, for userspace.   the primary thing to prevent
> from happening is to have kernelspace data structures from
> conflicting.
> 
>  i found kerrigan, btw, spoke to the people on it: louis agreed that
> the whole idea was mad as hell and was therefore actually very
> interesting to attempt :)
> 
>  as a first approximation i'm absolutely happy for existing pthreads
> applications to be forced to run on the same core.

The underlying problem across a cluster of nodes can be handled
transparently. MOSIX solved that problem a very long time ago using DSM
(distributed shared memory). It's not pretty, it requires a lot of tuning
to make it fly but they did it over comparatively slow interconnects.

Alan
