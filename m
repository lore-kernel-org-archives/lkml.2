Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1KGSi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:38:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56092 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab1KGSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:38:58 -0500
Date: Mon, 7 Nov 2011 18:39:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function
 flush_to_ldisc().
Message-ID: <20111107183950.4ec7a959@lxorguk.ukuu.org.uk>
In-Reply-To: <4EB822C7.6070200@ilyx.ru>
References: <4EB7BD9A.7070600@ilyx.ru>
	<20111107115802.23201d45@bob.linux.org.uk>
	<4EB7CCFF.5090304@ilyx.ru>
	<20111107130643.07e84fca@bob.linux.org.uk>
	<4EB7E0C6.7050909@ilyx.ru>
	<20111107145005.68ca1050@bob.linux.org.uk>
	<4EB822C7.6070200@ilyx.ru>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nested call flush_to_ldisc() happened on different CPU only. It happens because
> one side pty call "schedule_work(&tty->buf.work)" on one CPU from "tty_flip_buffer_push()",
> the other side call "schedule_work(&tty->buf.work)" from n_tty's layer from "n_tty_set_room()"
> on different CPU. It also can happen in interrupt if interrupt handle on 
> different CPU. Schedule_work() schedule work on CPU which was called(IMHO).

But the two sides are different ttys so that specific case shouldn't
matter.

Something is clearly happening because you trigger the trace but I don't
see why the paths you indicate cause it ? If you make mthread a cpu
struct variable and add a WARN_ON(1) in the error case do you get any
useful traces ?

Alan
