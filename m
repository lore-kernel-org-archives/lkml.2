Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1L3BFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:05:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62906 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1L3BF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111229120956.GA31878@elie.Belkin>
References: <20111207165611.GA19872@kroah.com> <20111207165602.672902223@clark.kroah.org>
 <20111229120956.GA31878@elie.Belkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Dec 2011 17:05:06 -0800
X-Google-Sender-Auth: pj7pi-WLetTDorIA5wqigTSoCxU
Message-ID: <CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
Subject: Re: [27/27] clockevents: Set noop handler in clockevents_exchange_device()
To: Jonathan Nieder <jrnieder@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Phil Miller <mille121@illinois.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 4:09 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>
> This is basically the reverse of 7c1e768974 (clockevents: prevent
> clockevent event_handler ending up handler_noop, 2008-09-03).  The
> rationale for the latter still applies.

Hmm. You seem to be right. Instead of applying this to stable, it
looks like we should revert it from mainline.

>                  People have been reporting
> the analagous patch to this one causing hangs on resume in 3.1.y and
> 3.2 release candidates:
>
>  - http://thread.gmane.org/gmane.linux.kernel/1233033
>  - http://thread.gmane.org/gmane.linux.kernel/1233389
>  - http://thread.gmane.org/gmane.linux.kernel/1233159
>  - http://thread.gmane.org/gmane.linux.kernel/1227868/focus=1230877
>
> So please consider reverting it for now.

Thomas? It does seem to be broken and there do seem to be regression
reports about it.

Should I revert it, or do you have alternative fixes?

                 Linus
