Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab1CXKYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:24:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47438 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756758Ab1CXKYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:24:12 -0400
Date: Thu, 24 Mar 2011 10:24:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Petr =?UTF-8?B?UMOtc2HFmQ==?= <ppisar@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean console safely
Message-ID: <20110324102431.5e017efe@lxorguk.ukuu.org.uk>
In-Reply-To: <1300960611-4820-1-git-send-email-ppisar@redhat.com>
References: <1300960611-4820-1-git-send-email-ppisar@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 10:56:51 +0100
Petr Písař <ppisar@redhat.com> wrote:

> Traditional \E[2J sequence erases console display but scroll-back
> buffer and underlying device (frame) buffer keep data that can be
> accessed by scrolling console back.
> 
> This patch introduce new \E[J parameter 3 that allows to scramble
> scroll-back buffer explicitly. Session locking programs (screen,
> vlock) can use it to prevent attacker to browse locked console
> history.
> ---
>  drivers/tty/vt/vt.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Looks sensible enough

There are a set of official codes that are probably more relevant, and
also deal with the timing of events

See DECSR/DECSRC on a later VT terminal, also DECSTR which 

DECSR = secure reset, return to power up state, \E[n+p where n is an
optional value from 1-16383 which if provided is replied back from the tty
as a DECSRC response (hence 'secure'). It's defined to clear off
screen memory, and also other weirdness a user may have set up so could
reasonably also be extended a bit if there is other stuff founbd in
future that such a reset really ought to clean up - eg for mingetty.

http://www.vt100.net/docs/vt520-rm/ek-vt520-rm.pdf (page 299)

ED 3J looks fine but is a new "made up" extension.

