Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab0JZQOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:14:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58485 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013Ab0JZQOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:14:43 -0400
Date: Tue, 26 Oct 2010 17:13:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe =?ISO-8859-14?B?Uul0b3JuYXo=?= 
	<philippe.retornaz@epfl.ch>
Cc: Alan Cox <alan@linux.intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ldisc: Fix BUG() on hangup
Message-ID: <20101026171342.580a1f94@lxorguk.ukuu.org.uk>
In-Reply-To: <201010261749.03875.philippe.retornaz@epfl.ch>
References: <201010261749.03875.philippe.retornaz@epfl.ch>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 17:49:03 +0200
Philippe Rétornaz <philippe.retornaz@epfl.ch> wrote:

> Hello
> 
> A kernel BUG when bluetooth rfcomm connection drop while 
> the associated serial port is open is sometime triggered.
> 
> It seems that the line discipline can disappear between the tty_ldisc_put  and 
> tty_ldisc_get. This patch fall back to the N_TTY line discipline if the 
> previous discipline is not available anymore.
> 
> This seem to fix the BUG(), but I don't know if it's correct.

I can see what you are trying to handle, and in theory you could if you
unload modules as they go unused hit a race there - I'm amazed it's
possible however.

The first part looks right - grab the reference before changing over and
error if it isn't available, and the second part follows logically,
although that bit of the hangup code is looking even more untidy now.

Acked-by: Alan Cox <alan@linux.intel.com>
