Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab1CZMIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 08:08:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41805 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750853Ab1CZMIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:08:20 -0400
Date: Sat, 26 Mar 2011 12:08:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Will Newton <will.newton@gmail.com>
Cc: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably not. Is it a virtual or physical indexed cache? Do you have a
> precise workload in mind? If you have a very precise workload and you
> don't expect to get many write conflicts then it could be made to
> work.

I'm unconvinced. The user space isn't the hard bit - little user memory
is shared writable, the kernel data structures on the other hand,
especially in the RCU realm are going to be interesting.

> There are a number of mature cores out there that can do this already
> and can be bought off the shelf, I wouldn't underestimate the
> difficulty of getting your cache coherency protocol right particularly
> on a limited time/resource budget.

Architecturally you may want to look at running one kernel per device
(remembering that you can share the non writable kernel pages between
different instances a bit if you are careful) - and in theory certain
remote mappings.

Basically it would become a cluster with a very very fast "page transfer"
operation for moving data between nodes.
