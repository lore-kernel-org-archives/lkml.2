Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0LFB7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:59:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0LFB7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x2QcQzxglfqL/S2qSLbCiJrI2AGHfj6y/geqU18Nr2w6H4kieahFYro0rpd2At2+Wg
         wno/EhMq8uQUM5iBx3dsqSi9g0CWoNYZ2UFKnlZ4AN1lrOSevoYLFIc3T5i50C8wBDBe
         ZjyXTX0CyTv+tWIAAtOI4C1iQeHt9zCa+xTMA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
	<AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
Date: Mon, 6 Dec 2010 09:59:37 +0800
Message-ID: <AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com>
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

On Sun, Dec 5, 2010 at 8:29 PM, Thiago Farina <tfransosi@gmail.com> wrote:
>
> On Sat, Dec 4, 2010 at 1:19 AM,  <bookjovi@gmail.com> wrote:
> > fix error handling path
> >
> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> >  kernel/perf_event.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index cb6c0d2..62f9e9d 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
> >        }
> >
> >        err = alloc_callchain_buffers();
> > -       if (err)
> > -               release_callchain_buffers();
>
> Care to explain in the change log message? As I reader, is not clear
> to me what is wrong with this.

Sorry, the description should be as:
fix error handling path. alloc_callchain_buffers() can return -ENOMEM,
in this time callchain_cpus_entries maybe is NULL, It will oops if
invoke release_callchain_buffers() when callchain_cpus_entries is
NULL.
