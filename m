Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2JWPpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:45:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45863 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab2JWPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:45:33 -0400
Message-ID: <5086BB94.3040208@zytor.com>
Date: Tue, 23 Oct 2012 08:45:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Rusty Russell <rusty@rustcorp.com.au>, mtk.manpages@gmail.com,
        linux-kernel@vger.kernel.org, jonathon@jonmasters.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com> <87sj97hs5e.fsf@rustcorp.com.au> <CAMOw1v7ySGT2g5s8djEbCGnqTNjqHky_LvaZsGEN6CSLNPMUgw@mail.gmail.com> <CAGXu5jK5wCnG0Ks+8YPgubX9dOir786hY4N+S3yTirK2-hBLqQ@mail.gmail.com> <CAMOw1v6bL2U2d6fKzqmGxk5GrjUzA7whcaCsp9e3EOOe+c=N_A@mail.gmail.com> <CAGXu5j+2vpA3J4sCUCaNkzCfO0yON2cVwSqFOiXku5u8GMwmmA@mail.gmail.com>
In-Reply-To: <CAGXu5j+2vpA3J4sCUCaNkzCfO0yON2cVwSqFOiXku5u8GMwmmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 08:42 AM, Kees Cook wrote:
>
> Hm, yeah, userspace mangling of a module plus signing would fail.
> Seems like mangling and signing aren't compatible. Doing it in
> kernel-space (as now written for finit_module) solves that, but it
> means that now compression isn't possible if you need both signing and
> mangling.
>
> I'm not a user of signing, compression, or mangling, so I'm probably a
> bit unimaginative here. It seems like the case for needing all three
> is pretty uncommon. (e.g. if you're doing compression, you're probably
> building embedded images, which means you're unlikely to need
> --force.)
>

In particular, mangling and signing aren't compatible... however, 
signing and compression should be just fine (sign before compression).

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

