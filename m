Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0LHBwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:52:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36187 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0LHBwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hn2Oyh2UhyFbKCACODyTZYK+x1+8BvmKotRllt9kFm3gVFBMjRyQH/+yyaKmEu2tuX
         XbB45y390C1d1BPg1I2fwH8LspJfaabBeFgfJqbOkgeY9jbjJh0MTCsKuZG6zD9twLSV
         06qEosRiZXR3vt7wjDCaa/XSUG204Kem1qnD4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com>
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
	<AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
	<AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com>
Date: Wed, 8 Dec 2010 09:51:59 +0800
Message-ID: <AANLkTi=HGdGs++FKY6=icEs3FTwSggXTu42JQ+1MCxBc@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix error handling path
From: jovi zhang <bookjovi@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 9:59 AM, jovi zhang <bookjovi@gmail.com> wrote:
> On Sun, Dec 5, 2010 at 8:29 PM, Thiago Farina <tfransosi@gmail.com> wrote:
>>
>> On Sat, Dec 4, 2010 at 1:19 AM,  <bookjovi@gmail.com> wrote:
>> > fix error handling path
>> >
>> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
>> >  kernel/perf_event.c |    2 --
>> >  1 files changed, 0 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> > index cb6c0d2..62f9e9d 100644
>> > --- a/kernel/perf_event.c
>> > +++ b/kernel/perf_event.c
>> > @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
>> >        }
>> >
>> >        err = alloc_callchain_buffers();
>> > -       if (err)
>> > -               release_callchain_buffers();
>>
>> Care to explain in the change log message? As I reader, is not clear
>> to me what is wrong with this.
>
> Sorry, the description should be as:
> fix error handling path. alloc_callchain_buffers() can return -ENOMEM,
> in this time callchain_cpus_entries maybe is NULL, It will oops if
> invoke release_callchain_buffers() when callchain_cpus_entries is
> NULL.
>
I hope my understanding is right, is it?
