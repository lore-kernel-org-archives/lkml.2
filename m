Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab2EIXuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:50:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47776 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760483Ab2EIXux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAHo-OowjvXat8dZOpp50GO_KSTYBy_Wa96wvFUfTXmua3oBrUw@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
 <CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com>
 <CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
 <CA+55aFyrSNTh3B7L=Lq1L_Hz=0NEPC95TWmo2-W9odKi+80XJg@mail.gmail.com> <CAHo-OowjvXat8dZOpp50GO_KSTYBy_Wa96wvFUfTXmua3oBrUw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 16:50:32 -0700
X-Google-Sender-Auth: 4koImgbbpt0_8NP-OVtNCMCAqcg
Message-ID: <CA+55aFyXP8PRusYYrpAnFfV=eL69ktfQfiGxAH1B-Ds8HH+bJQ@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 4:46 PM, Maciej Żenczykowski
<zenczykowski@gmail.com> wrote:
>
> Doesn't that just reintroduce the security 'hole' in buggy userspace apps
> that the original patch was attempting to fix?

Well, those bggy apps have to be really *odd* buggy apps now. IOW,
they need to do setuid(), and then not execve(). At that point, they
really do have to check the error return, since there is no execve()
for them to check.

In the end, we can do only so much to counter buggy apps. I think my
patch is a reasonable "we can try to give the error at execve() time,
but if somebody does tons of setuid() without ever doing the execve(),
at some point they do have to check the error return of setuid()
itself".

I suspect most users of setuid() are good and check the error return.

                       Linus
