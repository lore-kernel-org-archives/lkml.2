Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2GZRDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:03:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49166 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2GZRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:03:38 -0400
Date: Thu, 26 Jul 2012 18:07:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 6/7] kdb: Mark safe commands as KDB_SAFE and
 KDB_SAFE_NO_ARGS
Message-ID: <20120726180709.09777a3b@pyramind.ukuu.org.uk>
In-Reply-To: <1343312791-9138-6-git-send-email-anton.vorontsov@linaro.org>
References: <20120726142514.GA32158@lizard>
	<1343312791-9138-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following commands were marked as "safe":
> 
> 	Clear Breakpoint
> 	Enable Breakpoint
> 	Disable Breakpoint
> 	Display exception frame
> 	Stack traceback

This is sufficient to steal cryptographic keys in many environments. In
fact you merely need two or three breakpoints and to log the order they
are hit through the crypto computation.

> 	Display stack for process

Exposes all sorts of user data unless you mean just the call trace, in
which case it's still quite useful.

> 	Display stack all processes

Ditto

> 	Send a signal to a process

Like say sending SIGSTOP to security monitoring threads or the battery
manager on locked devices that rely on software battery management ?


It's an interesting idea but you need almost nothing to extract keys from
a system or to subvert it.

Alan
