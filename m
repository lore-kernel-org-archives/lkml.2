Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1GCRni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 13:43:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab1GCRng convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 13:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110703100131.GA2472@albatros>
References: <20110626190622.GB4217@albatros> <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros> <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros> <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros> <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros> <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
 <20110703100131.GA2472@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jul 2011 10:42:45 -0700
Message-ID: <CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 3, 2011 at 3:01 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> Sigh...  After implementing controls filtering including \n inside of
> %s, I got numerous false positives.  Most of them are startup messages
> with driver/hardware name/version, in drivers/.

Yeah, I was afraid of that. It's going to be a much bigger patch, and
likely somewhat annoying.

That said, if we really want to do this, I think doing it with %s
filtering is the only way, and it would make the default case where
people really don't think about possible user-supplied strings be
safe.

So saying "%s is for pure 7-bit ASCII with no control codes" is
annoying, but would really fix it.

That said, I think it should be unconditional. None of this "safe vs
unsafe" flags, and none of this "printk format strings are different
from other vsprintf format strings". If special characters are a
potential security problem for printk(), then they are a potential
security problem for other things (eg /proc filenames or content etc).

                    Linus
