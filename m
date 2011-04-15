Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1DOQLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:11:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65095 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DOQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oSqANv9fezbbf7wfrIX+Uky8/zoHoX3vlp1Vh87Oq2rQDFOGeqSiu8wUfBFkRoNnve
         vBxcspg2WLiEqcUjMhqp2t+N88lg+GQEy5wvZDXWnnzTvC25D3noFsuCvpVHM/apKjgj
         +beUkSosdQfDb618W5TT0Pfqy3zc4Km0SEy94=
MIME-Version: 1.0
In-Reply-To: <20110415143350.GM18463@8bytes.org>
References: <20110413193459.GL19819@8bytes.org>
	<4DA60C30.4060606@kernel.org>
	<BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
	<4DA6145D.9070703@kernel.org>
	<BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
	<4DA655E7.3000904@zytor.com>
	<BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
	<BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
	<20110415131152.GJ18463@8bytes.org>
	<20110415131650.GB18660@elte.hu>
	<20110415143350.GM18463@8bytes.org>
Date: Fri, 15 Apr 2011 12:11:04 -0400
Message-ID: <BANLkTikd2nUO+Obn_Ez0HqjbE5KO3Yt6CQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Alex Deucher <alexdeucher@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 10:33 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Apr 15, 2011 at 03:16:50PM +0200, Ingo Molnar wrote:
>> Ok, but how did the allocation changes start triggering this error in
>> v2.6.39-rc1? There must still be some layout specific thing here, right?
>> Do we understand the details of that as well?
>
> No, I must admit that I lack enough knowledge about the GPU hardware to
> make an guess how this tanslation-request happened. All I can tell is
> the address that was reported in the MCE, it is 0xa0001000 (==the second
> page of the GART aperture).
>
> Maybe Alex can help here. Alex, may it be possible that the GPU
> generates DMA requests in the GTT area before the GTT is activated (or
> the activation is completed)? Or can you imagine any other reason?

It shouldn't.  The driver binds a dummy page to all entries in the
table at init time and whenever the actual pages are unbound.

Alex
