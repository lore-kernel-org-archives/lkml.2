Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0KRLhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:37:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55828 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750854Ab0KRLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:37:21 -0500
Date: Thu, 18 Nov 2010 11:34:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101118113441.74fcdc21@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd like to see hardware bring up at companies being done with Linux.

I know several companies where it is sometimes used.

> with this though. For starters hardware teams typically want to get
> hardware brought up as fast as possible to be able to sell chipsets.
> Its always a race. Proper Linux upstream support will get there but
> depending on the company this may mean this gets done after the
> proprietary driver approach is done first or simply until you have a
> big enough customer to justify it.

I've seen the kind of code written to "get it up as fast as possible" and
also to do validation. It's the sort of code that has to be written
anyway, and which contains a multitude of fascinating stuff which doesn't
ever want to go near upstream.

> everything else can be independent code. For ath9k in particular this
> means we keep ath9k_hw shared between our Operating Systems and that's
> it. In addition to this I believe opening up the common drivers for

The Linux copy needs to be GPL, but if you own every line of it then you
can relicense it. In fact we have examples of big bits of code that are
not Linux only - eg the ACPI stack which are managed in a non entirely
unrelated way.

> Can Linux help in any way? What if we used staging for a common driver
> architecture for different OSes? 

It's generally gone pear shaped in the past, although tools like spatch
are more modern than many of those attempts.

There is another way to do it which is instead of writing a glue layer
for Linux write to the general Linux interfaces which have the virtue of
being very simple for the most part, and keep the glue layer for the
other obscure environments where you are doing the stack ?

Alan
