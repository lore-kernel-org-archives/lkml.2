Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0HQSY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:24:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55279 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab0HQSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=I8uGuPbbdb60tYkrbzx6ErG5mqD7k92eKVXkyG5jW1XwuPaS2fgGBYs+/af4TgVxvq
         4nc2fxk2JTG4q/xUxKCFRsLGNXtRcUkzhtADUHppLbs/I2yLb8/Kfd0mBhrgokAUKxKj
         Q56jg2bhJU7VGoEs3LpVHia1/St0Ypdmj8ZT4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
	<AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
Date: Tue, 17 Aug 2010 11:24:19 -0700
X-Google-Sender-Auth: S8Ycd2uYHrijlddEvPGMtXbpFlA
Message-ID: <AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 9:14 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> No. Looks like the rwsem changes broke sparc too. ia64 had some problems too.

I did have some similar mmap_sem issues - but the combination of
fixing the types
of the RWSEM_* defines to be unsigned, and the return value of
ia64_atomic64_add()
to be "long" rather than "int" looks to have cleared up the problems I
was seeing. I
could generally see the hung processes in less than 10 consecutive
kernel builds, but
ran a few thousand builds over the weekend with no issues.

If git is multi-threaded, it may be hitting some different code path
... but it isn't trivial
for me to try this out (my systems are on an isolated lab network segment).

-Tony
