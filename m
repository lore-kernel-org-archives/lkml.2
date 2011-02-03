Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1BCVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:16:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62873 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1BCVQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fg/42CZW3lyhMG/ndVaakcmrgjwgwfFZob0UlvX1YsnSRqer3gPuMdaUnMI73uY/Ad
         9udLbWO96WQ2a30tAjWOtr192Jbk28S+BuKX7VSPNnw4P7dFteExgerPkhGSHyu3PfYQ
         q5oGXXi1fVsgAC2BDI2QCDtBx/Amf5hPn5jVg=
MIME-Version: 1.0
In-Reply-To: <20110203190612.GL5843@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
	<20110201154947.GX16981@random.random>
	<20110203132407.GF11958@csn.ul.ie>
	<20110203190612.GL5843@random.random>
Date: Thu, 3 Feb 2011 22:16:17 +0100
Message-ID: <AANLkTimRE-=vB=oTFmc64fqJKHUTUT=3X_Gzx78PZ7Xu@mail.gmail.com>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
From: =?ISO-8859-2?Q?Jind=F8ich_Makovi=E8ka?= <makovick@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 20:06, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Feb 03, 2011 at 01:24:08PM +0000, Mel Gorman wrote:
>> This is very likely. Compaction calls into migration which will wait on
>> dirty pages after a time. With a large number of dirty pages backed by a
>> slow drive such as a USB stick, it could be getting stalled there for a
>> long period of time.
>>
>> Whether migration sleeps or not can be controlled by the sync parameter
>> passed into try_to_compact_memory which could be always forced to false
>> if GFP_NO_KSWAPD?
>
> I would expect that to hide any regression we could have because of
> more dirty cache in the system, yes.
>
> However Jindřich reported not being able to reproduce anything anymore
> in -rc3, so I'm unsure if we should make that change anymore. I asked
> to try again cause it should too easy that got fixed magically

I tried again and reproduced with -rc3 too, sorry for misinformation.

I also tried echo never >  /sys/kernel/mm/transparent_hugepage/defrag
, and it seems preventing the system freeze, but still the copying
itself sometimes comes to almost complete stop (GkrellM shows short
spikes of tens of kB/s on the USB /dev/sdX). In this case, khugepaged
is also in DN. I still didn't observe this problem when disabling THP
completely by echo never > enabled .

-- 
Jindrich Makovicka
