Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0FZBss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 21:48:48 -0400
Received: from md2.t-2.net ([84.255.209.81]:14989 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab0FZBsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 21:48:47 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	 <1277462596.2143.101.camel@itpsd6lap>
	 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 26 Jun 2010 03:48:31 +0200
Message-Id: <1277516912.29797.411.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0206.4C255C76.018F,ss=1,fgs=0,
	ip=192.168.1.20,
	so=2010-02-10 22:08:04,
	dmn=5.4.3/2007-10-18,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int tpk_write_room(struct tty_struct *tty)
> > +{
> > +	int ret = tpk_space;
> > +
> > +	/* allow char by char under max pressure */
> > +	if (tpk_space == 0)
> > +		tpk_space = 1;
> 
> That won't do what you think, the ldisc will keep seeing progress and
> generate millions of 1 byte I/Os in a loop !

I thought that this would automatically reduce processor load, which is
obviously not the case. Sorry for the delay, but i am trying to figure
out how to slow down write method when under pressure.

And that setting tpk_space to 1 would then be just in case we reach 0 to
enable further processing.

Samo


