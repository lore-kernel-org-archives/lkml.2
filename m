Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1F3DAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:00:49 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:38142
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab1F3DAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:00:43 -0400
Message-ID: <4E0BE6A9.3040708@akkadia.org>
Date: Wed, 29 Jun 2011 22:59:53 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org> <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com> <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com>
In-Reply-To: <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/29/2011 02:05 PM, Linus Torvalds wrote:
> Ok, minimally tested now, it seems to work from the one trivial
> test-case I wrote for it.
> 
> I'm not going to commit it, but if others think this is a reasonable
> thing to do and remind me during the next merge window, we can do it
> then.

It provides the information, yes, but it also hides some information.
If you do it this way we cannot distinguish code which uses O_CLOEXEC at
open-time from uses of fcntl(FD_CLOEXEC).

This is not needed for the specific application I have in mind.  But if
you, for instance, want to track down code which uses fcntl instead of
doing the work at open-time using O_CLOEXEC we would need this information.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk4L5qQACgkQ2ijCOnn/RHSplwCgrA7RXs9gI7sr4e7SuvYsI04b
dmEAnA9eD4k9ZdFoJuQvGoXkBkjolfZn
=6GVj
-----END PGP SIGNATURE-----
