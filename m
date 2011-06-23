Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1FWBaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:30:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61113 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab1FWBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TL9TG8mDPw5tTMags5IiEQv2j5tooN+FmU0SQB3bMcuDtsMrkqaEyhy98xeIlJJv2M
         D8giN78C/GoBrh3vUh1+q2xYYq3/IKftomEj4NwctbyfOa9XAJDSHOPhAqCFYysJP8FA
         H4wZBghvLE2kfFzzT3DEy23s8FRYgmfsG7ANo=
MIME-Version: 1.0
In-Reply-To: <20110622232532.GA20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<BANLkTikidXPzyxySbmrXK=EUXOzqMtm-0g@mail.gmail.com>
	<20110622232532.GA20843@redhat.com>
Date: Thu, 23 Jun 2011 09:30:33 +0800
Message-ID: <BANLkTim28RJ4Dn_WSLAyqjds1JMqXeYmEA@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Izik Eidus <izik.eidus@ravellosystems.com>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 7:25 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 07:13:54AM +0800, Nai Xia wrote:
>> I agree on this point. Dirty bit , young bit, is by no means accurate. Even
>> on 4kB pages, there is always a chance that the pte are dirty but the contents
>> are actually the same. Yeah, the whole optimization contains trade-offs and
>
> Just a side note: the fact the dirty bit would be set even when the
> data is the same is actually a pros, not a cons. If the content is the
> same but the page was written to, it'd trigger a copy on write short
> after merging the page rendering the whole exercise wasteful. The
> cksum plays a double role, it both "stabilizes" the unstable tree, so
> there's less chance of bad lookups, but it also avoids us to merge
> stuff that is written to frequently triggering copy on writes, and the
> dirty bit would also catch overwrites with the same data, something
> the cksum can't do.

Good point. I actually have myself another version of ksm(off topic, but
if you want to take a glance: http://code.google.com/p/uksm/ :-) )
that did do statistics of the ratio of the pages in a VMA that really got COWed.
due to KSM merging on each scan round basis.

It's  complicated to deduce a precise  information only
from the dirty and cksum.


Thanks,
Nai
>
