Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2JXL35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:29:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48089 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242Ab2JXL3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:29:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Kees Cook <keescook@chromium.org>
Cc: mtk.manpages@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, jonathon@jonmasters.org,
        "Mimi Zohar" <zohar@linux.vnet.ibm.com>,
        "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAMOw1v4KOcH+OckoFzWEr68aUweKD-6gH83BHmBm-1c7PqhCpQ@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com> <87sj97hs5e.fsf@rustcorp.com.au> <CAMOw1v7ySGT2g5s8djEbCGnqTNjqHky_LvaZsGEN6CSLNPMUgw@mail.gmail.com> <CAGXu5jK5wCnG0Ks+8YPgubX9dOir786hY4N+S3yTirK2-hBLqQ@mail.gmail.com> <CAMOw1v6bL2U2d6fKzqmGxk5GrjUzA7whcaCsp9e3EOOe+c=N_A@mail.gmail.com> <CAGXu5j+2vpA3J4sCUCaNkzCfO0yON2cVwSqFOiXku5u8GMwmmA@mail.gmail.com> <CAMOw1v4KOcH+OckoFzWEr68aUweKD-6gH83BHmBm-1c7PqhCpQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 24 Oct 2012 13:36:59 +1030
Message-ID: <87d308o9f0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
> On Tue, Oct 23, 2012 at 1:42 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Oct 22, 2012 at 9:08 PM, Lucas De Marchi
>> <lucas.demarchi@profusion.mobi> wrote:
>>> sure... but do you realize this will fail in case kernel is checking
>>> module signature and we passed --force to modprobe (therefore mangled
>>> the decompressed memory area)?
>>
>> Hm, yeah, userspace mangling of a module plus signing would fail.
>> Seems like mangling and signing aren't compatible. Doing it in
>> kernel-space (as now written for finit_module) solves that, but it
>> means that now compression isn't possible if you need both signing and
>> mangling.

Signing and mangling are always incompatible, of course.

Compressed modules breaks Kees' (and IMA's) requirement to have an fd
attached, unless the kernel does the decompression.  We have that code
already, in fact.

It would be easy to add a config option the recognize the compression
magic and uncompress in-kernel.  That would happen after the signature
check, of course, and Just Work.

Cheers,
Rusty.
