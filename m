Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2GHMzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 08:55:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54180 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2GHMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 08:55:49 -0400
Date: Sun, 8 Jul 2012 13:59:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Jukka Ollila <jiiksteri@gmail.com>,
        linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
Message-ID: <20120708135911.69fe9566@pyramind.ukuu.org.uk>
In-Reply-To: <CAPXgP11Om4T-U6e-uZVYsV0FcJtkgnMfa+v94R46v=xdbhm77w@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
	<20120706175501.GA11908@kroah.com>
	<CAPXgP11Om4T-U6e-uZVYsV0FcJtkgnMfa+v94R46v=xdbhm77w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch will not fix the underlying problem, but just make it behave
> more like it was and allow partial message reads. This is a years old
> problem, the net is full of bugreports of stuff going wrong with
> running dd bs=1 on /proc/kmsg. It is a really stupid idea, and can not
> work for many other reasons too. The interface can not safely be used
> that way, it does not have the usual semantics, it always returned 0
> for read() whenever it needed to.

If you are breaking the semantics perhaps that should also get fixed ?

Alan
