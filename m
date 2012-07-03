Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2GCRu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:50:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43015 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2GCRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:50:57 -0400
MIME-Version: 1.0
In-Reply-To: <1341337257.2406.1.camel@nayuki.kepstin.ca>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 10:50:35 -0700
X-Google-Sender-Auth: iiAmStgrpi1jwQ41ZTa1oo0_B1s
Message-ID: <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 10:40 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
>
> Ok, here's the dmesg output that I get:
>
> [    0.714316] floppy0: lock_fdc: -1 (out of 8)

Ok, thanks. That -1 definitely explains the long delay. It's using
"drive=-1" because it has no actual drive number, just the
*controller* number.

And the backtrace shows what's going on too: it's the

  user_reset_fdc(-1, FD_RESET_ALWAYS, false);

that passes in -1 as the floppy controller number.

Ugh.

It looks like the code meant for -1 to mean "regular delay"
(current_reqD), and -2 to mean MAXTIMEOUT. For some reason the "-1"
logic has gotten screwed.

                  Linus
