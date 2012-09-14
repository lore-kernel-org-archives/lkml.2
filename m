Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2INKo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:44:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58211 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2INKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:44:28 -0400
Date: Fri, 14 Sep 2012 11:49:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] pcmcia: synclink_cs: fix potential tty NULL dereference
Message-ID: <20120914114917.3ae5680d@pyramind.ukuu.org.uk>
In-Reply-To: <1347571806-5567-1-git-send-email-khoroshilov@ispras.ru>
References: <1347571806-5567-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012 01:30:06 +0400
Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> tty_port_tty_get() can return NULL after port hangup that may happen anytime.
> The patch adds checks that tty_port_tty_get() returns nonNULL around places
> where tty is actually used.

I don't believe you can simply skip the processing in this case howevver
on the rx side. You are no longer reading the state, draining the FIFO
etc. Have you tested this on actual hardware and faked the tty = NULL
case ?

The tx one looks better.

Alan
