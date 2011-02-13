Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1BMKrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 05:47:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33730 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1BMKrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 05:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jg6yZYDEdSoSng1FVEADUinQZTeZX3R6e6MMvrxpDuMs8wARtemh/y2TjAGYAVA1eF
         3QDXdTbWOqNwKQECUyjMKzmoXomuiLwQmHTHWgjYf/LKjVQ4+Al1uGkCAI3IbVsUce/7
         lnLip4xtbb6AqKQeDI64pxAcaQXLD4Jh5rnqE=
MIME-Version: 1.0
In-Reply-To: <20110204154800.GB30909@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
	<20110201154947.GX16981@random.random>
	<20110203132407.GF11958@csn.ul.ie>
	<20110203190612.GL5843@random.random>
	<AANLkTimRE-=vB=oTFmc64fqJKHUTUT=3X_Gzx78PZ7Xu@mail.gmail.com>
	<20110204154800.GB30909@random.random>
Date: Sun, 13 Feb 2011 11:47:01 +0100
Message-ID: <AANLkTi=C2ybbsfcRiZS2UjePBToVWQT_pnkiGTfuXv7s@mail.gmail.com>
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

2011/2/4 Andrea Arcangeli <aarcange@redhat.com>:
> On Thu, Feb 03, 2011 at 10:16:17PM +0100, Jindřich Makovička wrote:
>> I also tried echo never >  /sys/kernel/mm/transparent_hugepage/defrag
>> , and it seems preventing the system freeze, but still the copying
>> itself sometimes comes to almost complete stop (GkrellM shows short
>> spikes of tens of kB/s on the USB /dev/sdX). In this case, khugepaged
>> is also in DN. I still didn't observe this problem when disabling THP
>> completely by echo never > enabled .
>
> Ok then you may need this too:
>
>  echo never > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
>
> Compaction is likely too heavy so we need to look into that.

Sorry for the delay.

Yes, disabling both defrag settings also solves the problem:

echo never >/sys/kernel/mm/transparent_hugepage/defrag
echo no > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag

-- 
Jindrich Makovicka
