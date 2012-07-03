Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab2GCR7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:59:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64752 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2GCR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 10:58:44 -0700
X-Google-Sender-Auth: P7WtwCwdvNPCnoccLjWLPLJ1QKU
Message-ID: <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 10:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It looks like the code meant for -1 to mean "regular delay"
> (current_reqD), and -2 to mean MAXTIMEOUT. For some reason the "-1"
> logic has gotten screwed.

So it looks like current_reqD still exists, and sets the drive to
"current_drive". Which *should* be 0, as far as I can tell.  In fact,
since "current_drive" is printed out by DPRINTK(), we *know* it's 0
(it's the "0" in the "floppy0:" message).

But how the heck does it pick that bogus 20 second delay then? The -1
should have been caught by

        if (drive == current_reqD)
                drive = current_drive;

and then we should have used the regular delay for drive 0.

Jiri, any ideas?

                  Linus
