Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0KXNCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:02:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48048 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab0KXNCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:02:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mKYntOvG2zES/dzffEaNI1InpDywSySqXLwh1nUXXSFpoOScN6wgOqmeWVHAvTGEKT
         WwRW6MXcUzDJa55hf90xUzFHVjppBJIdUEtf2mmVikn8DqYbkppEFjL2dx78X5nu7d/I
         9yTNA9lq1fzaTAHOK6NNFL7ICQgkO7BBzr5AE=
MIME-Version: 1.0
In-Reply-To: <AANLkTinOAdDqmVo+zrEk=-EUri-CXBY1kukd96-ocHhL@mail.gmail.com>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
	<AANLkTinOAdDqmVo+zrEk=-EUri-CXBY1kukd96-ocHhL@mail.gmail.com>
Date: Wed, 24 Nov 2010 14:01:50 +0100
Message-ID: <AANLkTi=6r_N9wHk1xWQ8Tya34f1eeqjiT5F4jUOf2X8+@mail.gmail.com>
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 04:26:01PM +0600, Rakib Mullick wrote:
> On Wed, Nov 24, 2010 at 3:57 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Wed, 24 Nov 2010, Rakib Mullick wrote:
> >
> >
> > So, now the bp variable does not exist at all if CONFIG_FRAME_POINTER is
> > not defined.
>
> Yes - right. And its not used outside CONFIG_FRAME_POINTER.
>
> > That's going to make this line :
> >
> >          show_trace(NULL, NULL, &stack, bp);
> >
> Not clear what are you trying to say. Would you please, clear it up a bit?


I think Jesper is confused because your patch applies on -tip (tip/master or
tip/perf/core) where we have zapped the bp argument from show_trace() lately.

But in the mainline, show_trace() still has the bp argument.
