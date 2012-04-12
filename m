Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab2DLB0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:26:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40088 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab2DLB0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com> <CA+55aFy-CeLXstbceP7+co3AXrEWtifKF+8NWzhC7B-A8xBd-w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 18:19:58 -0700
X-Google-Sender-Auth: s4P4torghO4R_6n0MBG1KDZN4vY
Message-ID: <CA+55aFx6V_TpbghsG7xqoBree8ALAKWMA+qLeGg-8DNAno+peg@mail.gmail.com>
Subject: Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 4:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think we can easily drop IS_ENABLED() if it has been causing
> problems. And it clearly is.
>
> And I had never even looked at that generated file. It's disgusting.
> We need to stop doing that. It must be driving compile-times up too -
> just parsing that monster is RealWork(tm).

Oh, but I have a sick and twisted mind. And I'm incredibly smart and
photogenic too.

Here's an implementation of IS_ENABLED() that works in C. Well,
"gcc-C". It depends on the optimizer DTRT, but gcc really does seem to
do it.

Ready? You *will* go blind - blinded by the pure beauty and intellect
in this thing:

    #define IS_DEFINED(x) (__stringify(CONFIG_##x)[0]=='1')

That really is a piece of art. I'm expecting that the Guggenheim will
contact me any moment now about it.

Of course, the above does *not* work for a pre-processor, but hey, you
can't have everything. It literally is *only* valid in C code. You
can't have everything. In the pre-processor, you can just use

   #if CONFIG_OPTION

like you always could, or use another helper macro for the "defined(x)" magic.

                      Linus
