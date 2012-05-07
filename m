Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2EGPXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:23:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2EGPW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 May 2012 08:22:36 -0700
X-Google-Sender-Auth: T9Rwq5vR1rITkOr7m5x-EruJqbw
Message-ID: <CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, neilb@suse.de,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 3:06 AM, Maciej Żenczykowski
<zenczykowski@gmail.com> wrote:
>
> Having read the commit in question I get what it is trying to prevent,
> but perhaps the setuid call should still be returning an error code
> [E2BIG? EBUSY? EOVERFLOW? ENAVAIL?] for those programs that do bother
> to check, even though it would 'succeed' in changing uid?
>
> (In my case there is no exec following the setuid...)

But that means that in your case the setuid() did actually succeed.

So you didn't get an error return, and the setuid() actually worked.
Only a later exec() would cause an error, but since you didn't do an
exec(), everything should be perfectly fine.

So returning an error would actually be confusing: it would make the
caller think that the setuid() failed and that you're still running
with the old uid. But it isn't.

So can you explain what the problem is for your workload? As far as I
can tell, it should all work perfectly well.

                       Linus
