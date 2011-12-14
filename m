Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1LNPzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:55:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1LNPzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <1323872631.28489.37.camel@twins>
References: <1323804803.9082.40.camel@twins> <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
 <20111214104308.14d0500c@pyramind.ukuu.org.uk> <1323860206.28489.35.camel@twins>
 <20111214140527.GA18080@thunk.org> <1323872631.28489.37.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Dec 2011 07:54:47 -0800
X-Google-Sender-Auth: 9alIqovNBpO1_RrV-KlMogPQS88
Message-ID: <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
Subject: Re: printk() vs tty_io
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 6:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> printk() goes through serial8250_console_write() which writes to the
>> UART device using a busy loop, with local IRQ's disabled.  So it's not
>> serial8250_console_write() which is waking things up; this is coming
>> form interrupt handler running on some different CPU.
>
> Which can still deadlock you just fine..

Ugh. There is a *ton* of stuff inside that serial port lock,
including, yes, the uart_write_wakeup().

And it does look like it's protecting port->tty or something, so I
don't see that we can just move the wakeup to outside the lock, which
was my first reaction.

Ugh.

                  Linus
