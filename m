Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1DTJzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:55:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34142 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753840Ab1DTJzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:55:42 -0400
Date: Wed, 20 Apr 2011 10:56:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.39-rc2, framebuffer] use after free oops
Message-ID: <20110420105631.70695dfa@lxorguk.ukuu.org.uk>
In-Reply-To: <20110420080535.3edd11ac@pluto.restena.lu>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
	<BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
	<20110420080535.3edd11ac@pluto.restena.lu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 08:05:35 +0200
Bruno Prémont <bonbons@linux-vserver.org> wrote:

> On Wed, 20 Apr 2011 13:50:10 Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> > Any ideas on how best to address this issue [0], since it causes
> > silent corruption, or at best crashes?
> 
> There is probably no easy short-term fix to this... 

The short term fix would be to deliberately leak the buffer. That should
go into 2.6.39-rc right now with a comment explaining the situation.
Otherwise who knows what corruption may occur to user data if unlucky.

The other 'cheat' might be to tweak the API so the removal API isn't a
'destroy' interface but a 'shut down' and has a matching 'restart' one
for when the intelfb unloads at which point vga16fb can carry on with the
original fb_info 8)

Alan
