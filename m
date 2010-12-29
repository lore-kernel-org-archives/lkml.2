Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0L2Qoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 11:44:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42014 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750847Ab0L2Qo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 11:44:28 -0500
Date: Wed, 29 Dec 2010 16:41:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Russ Gorby <richardx.r.gorby@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: smatch stuff: serial: ifx6x60: oops on load
Message-ID: <20101229164134.7eb982a4@lxorguk.ukuu.org.uk>
In-Reply-To: <20101220091555.GR1936@bicker>
References: <20101220091555.GR1936@bicker>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 12:15:55 +0300
Dan Carpenter <error27@gmail.com> wrote:

> Smatch complains that the ifx6x60 driver in linux-next has a NULL
> dereference.
> 
> drivers/serial/ifx6x60.c +986 ifx_spi_spi_probe(27)
> 	error: potential null derefence 'pl_data'.
> 
>    984          ifx_dev->spi_timer.function = ifx_spi_timeout;
>    985          ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
>    986          ifx_dev->is_6160 = pl_data->is_6160;
>                                    ^^^^^^^
> "pl_data" is always NULL at this point.  Presumably this crashes on load
> every time.

Getting the platform enabling patch in is on the todo list but it depends
on some other bits which are also not yet in the tree.

is_6160 needs to go anyway as it's not what the platform data really
indicates.

