Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab1DYSAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:00:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53521 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab1DYSAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=iHIhGFYnxGvLPcZlWUvsLMbNScY3Zxoa3llGFsHlzK1ewJXxGQBpG7KmY5Oy1emDFt
         YXgY8wZeRx3L1SEnfXhcjpjccOxgD6Nyr7wbKOj8/1vatncjtRDAxz8F4/fMWJX2rxxK
         C2cj/viFBsLClJG94ir8HVXV4l8keusbJT4+w=
MIME-Version: 1.0
In-Reply-To: <20110425174110.GB28239@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<20110422165007.GA18401@vps.sharma-home.net>
	<20110422203022.GA20573@elte.hu>
	<20110422203222.GA21219@elte.hu>
	<20110423000347.GC9328@tassilo.jf.intel.com>
	<1303545012.2298.44.camel@twins>
	<20110424021907.GB3019@alboin.amr.corp.intel.com>
	<20110425174110.GB28239@elte.hu>
Date: Tue, 26 Apr 2011 02:00:10 +0800
Message-ID: <BANLkTinNzALr0m1gq=Brk4oLq3A=3Py1yQ@mail.gmail.com>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Dehao Chen <danielcdh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 1:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andi Kleen <ak@linux.intel.com> wrote:
>
> > > You're so skilled at not actually saying anything useful. Are you
> > > perchance referring to the fact that the IP reported in the PEBS data is
> > > exactly _one_ instruction off? Something that is demonstrated to be
> > > fixable?
> >
> > It's one instruction off the instruction that was retired when the PEBS
> > interrupt was ready, but not one instruction off the instruction that caused
> > the event. There's still skid in triggering the interrupt.
>
> Peter answered this in the other mail:
>
>  |
>  | Sure, but who cares? So your period isn't exactly what you specified, but
>  | the effective period will have an average and a fairly small stdev (assuming
>  | the initial period is much larger than the relatively few cycles it takes to
>  | arm the PEBS assist), therefore you still get a fairly uniform spread.
>  |
>
> ... and the resulting low level of noise in the average period length is what
> matters. The instruction itself will still be one of the hotspot instructions,
> statistically.

Not true. This skid will lead to some aggregation and shadow effects
on some certain instructions. To make things worse, these effects are
deterministic and cannot be removed by either sampling for multiple
times or by averaging among instructions within a basic block. As a
result, some actual "hot spot" are not sampled at all. You can simply
try to collect a basic block level CPI, and you'll get a very
misleading profile.

Dehao

>
> Thanks,
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
