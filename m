Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1CTV6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:58:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47800 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751043Ab1CTV6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:58:18 -0400
Date: Sun, 20 Mar 2011 21:58:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Mac <kmac@poczta.fm>, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
Message-ID: <20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
In-Reply-To: <4D864A82.4090104@fastmail.fm>
References: <fuopaigyaypsqveewtjx@pwmq>
	<4D864A82.4090104@fastmail.fm>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +        spin_lock_irqsave(&dc->spin_mutex, flags);
>           if (port->port.count)
>               room = kfifo_avail(&port->fifo_ul);
> -        mutex_unlock(&port->tty_sem);
> +        spin_unlock_irqrestore(&dc->spin_mutex, flags);

dc->spin_mutex does not protect port->port.count.
