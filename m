Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab1D0Luz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:50:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41210 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756182Ab1D0Luy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:50:54 -0400
Date: Wed, 27 Apr 2011 12:52:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lifeng Sun <lifongsun@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket should
 return ENOTTY
Message-ID: <20110427125201.18395e2f@lxorguk.ukuu.org.uk>
In-Reply-To: <1303901103.3166.30.camel@edumazet-laptop>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	<1303883910.2699.53.camel@edumazet-laptop>
	<20110427104738.2bdbe228@lxorguk.ukuu.org.uk>
	<1303901103.3166.30.camel@edumazet-laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I wont argue the point, especially if you Ack the changes ;)
> 
> My only concern was to not break old applications, I dont know if it is
> going to break _any_ of them. Probably these old applications stick with
> old kernels.

The number of applications that actually check ioctl error codes beyond
if error perror; return is pretty small and those that do generally do so
for very narrow cases or for things like EWOULDBLOCK/EINTR stuff.

> If you ask me ENOTTY is plain wrong.
> ioctl() is not restricted to terminal devices at all.

Like the tab/space thing in Makefiles and Qwerty keyboards its now part of
how stuff all works but EINVAL is even worse because you cannot tell
between 'this ioctl isn't know/is used on the wrong fd' and 'argument
wrong to valid ioctl'

Alan
