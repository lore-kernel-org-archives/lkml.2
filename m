Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1HHGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:16:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33918 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1HHGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:16:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
References: <20110805010038.GA18148@redhat.com>
	<20110805084614.GA1588@x4.trippels.de>
	<CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
	<alpine.DEB.2.00.1108051131440.28580@router.home>
	<20110805163948.GA11113@redhat.com>
	<alpine.DEB.2.00.1108051146180.28580@router.home>
	<20110805165119.GA11593@redhat.com>
	<alpine.DEB.2.00.1108051158400.28580@router.home>
	<20110805171607.GA11703@redhat.com>
	<alpine.DEB.2.00.1108051312090.28580@router.home>
	<20110805182008.GA22314@redhat.com>
	<CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
	<alpine.DEB.2.00.1108072155240.9480@tiger>
	<CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
	<alpine.DEB.2.00.1108080817050.25955@tiger>
	<CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
Date: Mon, 8 Aug 2011 09:16:54 +0300
X-Google-Sender-Auth: ej7Gfqn5I8jmWKs_-KaMwowr5uI
Message-ID: <CAOJsxLFT8AT9HOii4ivAyx0zNLmeJhoYinGU3+Sadnu+Zn7MSA@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 9:14 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Mon, Aug 8, 2011 at 1:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> Hi Linus,
>>
>> On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>>>
>>>> Christoph, I've been reading the code and spotted two potential issues in
>>>> __slab_free(). The first one seems like an off-by-one where our
>>>> comparison
>>>> in deactivate_slab() doesn't match __slab_free.
>>>>
>>>> The other one is remove_full() call in __slab_free() that can get called
>>>> even if cache debugging is not enabled.
>>>>
>>>> Hmm?
>>
>> On Sun, 7 Aug 2011, Linus Torvalds wrote:
>>>
>>> I'd like to do -rc1 today, regardless of whether this fixes things or
>>> not (-rc1 is already a few days delayed).
>>>
>>> The patch seems to be a good fix, and a likely candidate for the
>>> corruption. Commit log and sign-off? I assume you've given it some
>>> testing, even if you couldn't reproduce the original issue?
>>
>> No, I haven't tested the patch myself but here's one in proper format in
>> case someone wants to test it.
>
> I applied it and I'm still seeing the corruption warning start from this :(

Thanks for testing. Can you share your .config, please?
