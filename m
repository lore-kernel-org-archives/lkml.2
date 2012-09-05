Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab2IEXN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:13:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45546 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2IEXN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:13:26 -0400
Date: Thu, 6 Sep 2012 00:18:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: A workaround for request_firmware() stuck in module_init
Message-ID: <20120906001804.645c243c@pyramind.ukuu.org.uk>
In-Reply-To: <1346879334.19098.1.camel@pasglop>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	<20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	<CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
	<20120905173011.7a1111f0@pyramind.ukuu.org.uk>
	<1346879334.19098.1.camel@pasglop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But then you have cases where probe() -> register_with_my_subsystem() ->
> open(). Network devices come to mind. IE. udev must be able to deal with
> a synchronous firmware load from probe I'm afraid.

I don't believe so. You have

	begin probe
		find match .. .firmware_name is set
		issue firmware load request
		set defer flag
	end probe

Later..

	firmware load complete
	kick probe up arse

	begin probe
		find match .. .firmware is loaded
		call ->probe()
		register
		open
		happiness
	end probe

Alan
