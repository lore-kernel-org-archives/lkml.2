Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1BIJky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:40:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46357 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753369Ab1BIJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:40:52 -0500
Date: Wed, 9 Feb 2011 09:44:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jayson R. King" <dev@jaysonking.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>
Subject: Re: 2.6.27.58-rc1 build error Re: [PATCH 21/23] hvc_console: Fix
 race between hvc_close and hvc_remove
Message-ID: <20110209094434.3928bf26@lxorguk.ukuu.org.uk>
In-Reply-To: <4D52080A.1090100@jaysonking.com>
References: <4D52080A.1090100@jaysonking.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011 21:20:42 -0600
"Jayson R. King" <dev@jaysonking.com> wrote:

> drivers/char/hvc_console.c: In function 'hvc_open':
> drivers/char/hvc_console.c:315: error: implicit declaration of function 
> 'tty_kref_get'
> drivers/char/hvc_console.c:324: warning: assignment makes pointer from 
> integer without a cast
> drivers/char/hvc_console.c:341: error: implicit declaration of function 
> 'tty_kref_put'
> drivers/char/hvc_console.c: In function 'hvc_poll':
> drivers/char/hvc_console.c:558: warning: assignment makes pointer from 
> integer without a cast
> drivers/char/hvc_console.c: In function 'hvc_remove':
> drivers/char/hvc_console.c:759: warning: assignment makes pointer from 
> integer without a cast
> 
> I don't see a tty_kref_get or tty_kref_put on 2.6.27. Those functions 
> first appeared in 2.6.28.

Correct - for 2.6.27 I don't think you *can* make the tty layer
non-exploitable without a major backport

Alan
