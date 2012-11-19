Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2KSG6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:58:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2KSG6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:58:11 -0500
Date: Mon, 19 Nov 2012 12:27:53 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Kees Cook <keescook@chromium.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz> <20121025120952.GI2616@ZenIV.linux.org.uk> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
 <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz> <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
 <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz> <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz>
 <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz> <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Sun, 18 Nov 2012, Kees Cook wrote --+
| This is the second problem. I view this as less critical because it's only 
| 64 instead of 4, but it certainly should be solved as well.

  I don't mean to be rude, but the patch I had sent solves both of these 
problems with much less performance hit.

Please see -> https://lkml.org/lkml/2012/10/26/442

Worst case: instead of 2^6(64) recursions, it would make only 4 calls to 
request_module() function. find_module() does not resolve module aliases, it 
could be removed from the above patch.

Please pardon me if I came across rude or offensive, I'm only trying to make a 
case.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
