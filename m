Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1CBQr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:47:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CBQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cDzY/D+wc0yHYLdQ+r5zAJ5crkgtv0wXcixrfWfdmSAo2ydB6BImOfiumGSyEQlWQw
         3KNKCetQzQ6XAFh8RobmivpDCZrV6JP1hSf5IR9EeoX3UpDEJ0gUYPfWClPrpvNUKN8+
         zbHaYcLhYWrVf2Acmr127qqnwArE4nwJdjJ9I=
MIME-Version: 1.0
In-Reply-To: <20110302161900.GP3319@htj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
	<AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
	<20110302161900.GP3319@htj.dyndns.org>
Date: Wed, 2 Mar 2011 08:47:54 -0800
X-Google-Sender-Auth: t7ZG0Ca5GkDEf2pR9SdntuSOzBI
Message-ID: <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com>
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 08:19 AM, Tejun Heo wrote:
> > Hey, Yinghai.
> >
> > On Tue, Mar 01, 2011 at 02:41:55PM -0800, Yinghai Lu wrote:
>>> >>> 2. find_early_table_space() always calculates the amount of the needed
>>> >>>   space from 0 to the specified @end.  As nodes are registered, each
>>> >>>   node would try to allocate accumulative amount of space for page
>>> >>>   table.  This probably wouldn't cause any actual problem (may affect
>>> >>>   emulated configurations a bit tho).
>> >>
>> >> interesting.
> >
> > Yeah, it's a pretty interesting piece of code in need of some cleanup.
No, i mean second one is not causing any problem.

that only take end is intentionally. that will make sure we can get
space for page table even in extreme case.

> >
> > I'm reverting the NUMA-affine page table allocation for now.  I wish
> > something like the following happens during the next devel cycle.
> >
> > * General cleanup of page table allocation code.  I'm not talking
> >   about major rewrite or anything major.  Just making the code sane(r)
> >   so that they take parameters instead of doing subtle stuff with
> >   internal #ifdef's.  And hopefully proper documentation.
> >
> > * Redo the NUMA-affine page table allocation in simpler way using
> >   cleaned up allocation functions.  As suggested before, IMO, just
> >   taking top and bottom of nodes is enough.  Again, hopefully, with
> >   enough documentation on both what and why.
> >
> > If you're interested in doing the above, please go ahead and let me
> > know.

No. please don't revert it.

Ingo, please get patches that will align to 1G ... from

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
memblock

Thanks

Yinghai
