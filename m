Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2ECULR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:11:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57513 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECULQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:11:16 -0400
Message-ID: <1336075862.6509.10.camel@twins>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 22:11:02 +0200
In-Reply-To: <CA+55aFx1BO-s1YZ3EwscdWh2y5C2Q2dUyH8xQmuBKTNZrZWTNA@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
	 <CA+55aFxhQ3SQrZJ6KGDu0xQ6sWSDxrS1C-V_fBcgCYmSqAKSWQ@mail.gmail.com>
	 <1336075373.6509.9.camel@twins>
	 <CA+55aFx1BO-s1YZ3EwscdWh2y5C2Q2dUyH8xQmuBKTNZrZWTNA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 13:09 -0700, Linus Torvalds wrote:
> On Thu, May 3, 2012 at 1:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Thing is, with bonkers stuff like usb-console and kms/drm that's a _lot_
> > of code running under the logbuf/console locks.
> 
> The top-level console lock shouldn't be a problem - we use trylock and
> delay if it is held.
> 
> It's the lower-level driver-specific locks that screw us up. And quite
> frankly, I am *not* willing to say that that is a printk() problem.
> That is purely a "USB serial console is damn well broken" issue, and
> should not be considered a limitation of printk.

I'm happy to call all that broken ;-)
