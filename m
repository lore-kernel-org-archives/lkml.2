Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab2EUSdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:33:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33192 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2EUSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:33:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
References: <20120521.050300.1434374935904126254.davem@davemloft.net>
 <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com>
 <20120521182400.GA6043@merkur.ravnborg.org> <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 11:33:12 -0700
X-Google-Sender-Auth: joUIaUDmbHsbo9DNgMlHLEHUqxI
Message-ID: <CA+55aFy4He9X6wQjATaJukzH1FkyhGqnmC4kb+azKuMmjPGbmg@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I didn't bother looking at *why* it warns, but all other architectures
> have the "if NET" part.

Ok, I looked now, and it's because the definition of HAVE_BPF_JIT is
inside the "if NET" thing.

So if NET isn't enabled, then HAVE_BPF_JIT doesn't really *exist* as
an option. Doing a "select" on it is thus not a good idea.

I bet you could just move the two lines

  config HAVE_BPF_JIT
          bool

up to the top of net/Kconfig (so that HAVE_BPF_JIT is available
unconditionally), and then remove all the "if NET" from the four
architectures that support it.

                  Linus
