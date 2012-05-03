Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2ECUKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:10:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <1336075373.6509.9.camel@twins>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
 <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com> <1336075373.6509.9.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 13:09:47 -0700
X-Google-Sender-Auth: u5oK5UHNLmlxbhxeu6UgUA-2xcc
Message-ID: <CA+55aFx1BO-s1YZ3EwscdWh2y5C2Q2dUyH8xQmuBKTNZrZWTNA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 1:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Thing is, with bonkers stuff like usb-console and kms/drm that's a _lot_
> of code running under the logbuf/console locks.

The top-level console lock shouldn't be a problem - we use trylock and
delay if it is held.

It's the lower-level driver-specific locks that screw us up. And quite
frankly, I am *not* willing to say that that is a printk() problem.
That is purely a "USB serial console is damn well broken" issue, and
should not be considered a limitation of printk.

                  Linus
