Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0IPRg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:36:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0IPRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:36:28 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=G6fJhtGuX8gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=lSXtbPDDt1nP9Sa6TPAA:9 a=Nk1V4vcJLdc1d_TXfNlTpxpnMPwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2] drivers/net/usb/hso.c: prevent reading
 uninitialized memory
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, j.dumon@option.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, davem@davemloft.net, stable@kernel.org
In-Reply-To: <20100916184735.1699492e@lxorguk.ukuu.org.uk>
References: <1284587008.6275.95.camel@dan>
	 <20100916155745.GB14318@home.goodmis.org>
	 <20100916180710.07821bdd@lxorguk.ukuu.org.uk>
	 <1284655960.23787.34.camel@gandalf.stny.rr.com>
	 <20100916184735.1699492e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Sep 2010 13:36:25 -0400
Message-ID: <1284658585.23787.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:47 +0100, Alan Cox wrote:

> If you want to micro-optimise it you can enumerate the cases that
> tiocmget can be NULL in that driver..

Heh, I think that's going a bit too far. Of course mico-optimizations
usually make the system go faster, but not enough to show out of the
noise, and micro-optimizations most of the time just make the code
harder to understand and more error prone.

A lot of the patches in this patch set could just do the:

	struct foo bar = { 0 };

This would let gcc optimize what needs to be done, and avoids a function
call to memset.

-- Steve


