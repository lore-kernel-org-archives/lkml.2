Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1LMXxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:53:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61605 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1LMXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:52:57 -0500
MIME-Version: 1.0
In-Reply-To: <1323804803.9082.40.camel@twins>
References: <1323804803.9082.40.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Dec 2011 15:52:35 -0800
X-Google-Sender-Auth: X3fMM-YoYmCyA4yNiqjnnW7pNHk
Message-ID: <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
Subject: Re: printk() vs tty_io
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> I've been poking at reducing the constraints on printk(), like make it
> work under rq->lock etc..

You aren't supposed register a console that wakes things up. But the
only console that honors that afaik is the traditional vt console.
*Maybe* the network console, I didn't check.

I *assume* you only get this lockdep warning if you have a serial console?

                       Linus
