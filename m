Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0FUOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:34:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211Ab0FUOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:34:27 -0400
Date: Mon, 21 Jun 2010 15:38:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100621153858.444695c0@lxorguk.ukuu.org.uk>
In-Reply-To: <1276291932.2154.45.camel@itpsd6lap>
References: <1273918658.2341.17.camel@itpsd6lap>
	<1275171436.2122.29.camel@itpsd6lap>
	<20100529235402.296406d9@lxorguk.ukuu.org.uk>
	<1275175983.2122.42.camel@itpsd6lap>
	<1276123020.16010.97.camel@itpsd6lap>
	<20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	<1276291932.2154.45.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm thinking to leave the ratelimit support in for the time being. I had
> in mind cases, when someone does
>  "cat /proc/kmsg > dev/ttyprintk" or
> suppose the console is redirected to ttyprintk (which i would like to be
> able to do from user program)

Console as in the printk sense would then loop.

If you are going to do the flow control you should probably do something
like


write_room()
{
	if (!flow_controlled)
		space = 8192;
	return space;
}

write()
{
	space -= len;
}

then your flow control will behave properly and slow down users rather
than losing data (except stuff sent without blocking)

