Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0GNLtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:49:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56242 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137Ab0GNLtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:49:03 -0400
Date: Wed, 14 Jul 2010 12:58:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ed W <lists@wildgooses.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100714125817.7eb3bc01@lxorguk.ukuu.org.uk>
In-Reply-To: <4C3D94E3.9080103@wildgooses.com>
References: <4C3D94E3.9080103@wildgooses.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  From what I can see the linux initial congestion window is signficantly 
> limiting me here, with slow start taking many many seconds to open up 
> the window wide enough to get the data flowing?  For protocols like http 
> this is really hurting with all the short lived connections never really 
> getting up to speed.  (throw in some random packet loss and things 
> really screech to a halt)

For http it's the window the server end that will matter as most data
goes server->client. http also has HTTP/1.1 so that in the normal case
you don't get lots of small connections.

An http request is normally sub MTU size (unless it's got auth and lots
of cookie crap) so your congestion window should be irrelevant. It's the
cwnd the other end that will matter.

Have you considered running a web proxy the other end of the link. That
would keep the DNS lookup work on the fast rtt side, and mean if your web
browser is being sane you are maintaining one connection for most of your
work. It also means you can run advert and junk filters the better end.

If you want to explore it further you want: netdev@vger.kernel.org really.

Alan
