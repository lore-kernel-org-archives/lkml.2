Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab2D0Rgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:36:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42845 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2D0Rgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:36:39 -0400
Date: Fri, 27 Apr 2012 18:39:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty, add kref to sysrq handlers
Message-ID: <20120427183922.47436912@pyramind.ukuu.org.uk>
In-Reply-To: <1335546920-28492-1-git-send-email-prarit@redhat.com>
References: <1335546920-28492-1-git-send-email-prarit@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the lock were removed, however, there is one _unlikely_ circumstance in
> which the array would be left unprotected.  That would be the situation in
> which a module was loaded and the sysrq handler was registered during the
> execution of the module.  Again, the possibility of the scenario is very
> small and given the existing usage of unregister_sysrq_key() in the tree
> it seems like removing the lock is sufficient.

It's asking for later disasters I think.

I'm not sure I see we need a kref - that looks like overkill, and its
probably even more elegantly done with RCU ?

> Of course, I'm more than willing to hear additional suggestions.  A rw
> lock still requires that it be taken with irqs disabled so IMO it is out
> of the question.

One approach would be to defer the work. Is there any reason a slow sysrq
handler shouldn't be expected to behave itself and schedule work to run
later. The module unload killing the work will take care of all the other
unload stuff.

Alan
