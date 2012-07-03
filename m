Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab2GCXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:01:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41016 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab2GCXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120703194047.GN11413@one.firstfloor.org>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
 <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
 <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz> <20120703185808.GM11413@one.firstfloor.org>
 <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com> <20120703194047.GN11413@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 16:01:28 -0700
X-Google-Sender-Auth: X2SI8eW0ozWLBcc-J3vt7eJzdAA
Message-ID: <CA+55aFxjFR0eEDUSevtO2dytF0Bqt-UtCAnQpxo8Lnv9AbfxJg@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Calvin Walton <calvin.walton@kepstin.ca>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 12:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> That works.  Patch cuts it down to 3s as before

Ok, I committed it and pushed out.

That said, I'm surprised that you report that the revert doesn't work,
though. Before commit 070ad7e793dc, there was a "del_timer()" there,
and re-introducing that del_timer() (and canceling the work is the
equivalent of that) should have taken care of the issue.

Odd, but I can't find it in myself to care too much.

               Linus
