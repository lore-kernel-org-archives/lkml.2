Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2GQOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:46:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44851 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2GQOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207170929290.13599@router.home>
References: <1342221125.17464.8.camel@lorien2>
	<alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com>
	<CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com>
	<1342407840.3190.5.camel@lorien2>
	<alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1207160915470.28952@router.home>
	<alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1207161506390.32319@router.home>
	<alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1207170929290.13599@router.home>
Date: Tue, 17 Jul 2012 17:46:13 +0300
X-Google-Sender-Auth: zZp1TepfdYlJZgo_BhS7fBqBRgs
Message-ID: <CAOJsxLECr7yj9cMs4oUJQjkjZe9x-6mvk76ArGsQzRWBi8_wVw@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Shuah Khan <shuah.khan@hp.com>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, David Rientjes wrote:
>> > The kernel cannot check everything and will blow up in unexpected ways if
>> > someone codes something stupid. There are numerous debugging options that
>> > need to be switched on to get better debugging information to investigate
>> > deper. Adding special code to replicate these checks is bad.
>>
>> Disagree, CONFIG_SLAB does not blow up for a NULL name string and just
>> corrupts userspace.

On Tue, Jul 17, 2012 at 5:36 PM, Christoph Lameter <cl@linux.com> wrote:
> Ohh.. So far we only had science fiction. Now kernel fiction.... If you
> could corrupt userspace using sysfs with a NULL string then you'd first
> need to fix sysfs support.
>
> And if you really want to be totally safe then I guess you need to audit
> the kernel and make sure that every core kernel function that takes a
> string argument does check for it to be NULL just in case.

Well, even SLUB checks for !name in mainline so that's definitely
worth including unconditionally. Furthermore, the size related checks
certainly make sense and I don't see any harm in having them as well.

As for "in_interrupt()", I really don't see the point in keeping that
around. We could push it down to mm/slab.c in "__kmem_cache_create()"
if we wanted to.

                                Pekka
