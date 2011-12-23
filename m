Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1LWMU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:20:26 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38452 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab1LWMUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:20:24 -0500
Message-ID: <4EF471ED.1030902@metafoo.de>
Date: Fri, 23 Dec 2011 13:19:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, mmarek@suse.cz
Subject: Re: [Cocci] [PATCH 2/2] coccinelle: Add patch for replacing open-coded
 IS_ERR_OR_NULL
References: <1324301063-16117-1-git-send-email-lars@metafoo.de> <1324301063-16117-2-git-send-email-lars@metafoo.de> <alpine.DEB.2.02.1112202321220.1933@hadrien> <4EF1C7D3.7080301@metafoo.de> <alpine.DEB.2.02.1112211308290.1826@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1112211308290.1826@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 01:10 PM, Julia Lawall wrote:
> On Wed, 21 Dec 2011, Lars-Peter Clausen wrote:
> 
>> On 12/20/2011 11:24 PM, Julia Lawall wrote:
>>> For this one, I made quite a number of changes, some of which required
>>> fixing a bug in Coccinelle...  I will try to release the bug fix
>>> shortly. In general, though, I have added ... between the two tests.  I
>>> also got rid of the focus on ifs in the org and report rules.
>>>
>>
>> Ok, thanks. Was the removing of the ifs in related to the Coccinelle
>> bug? I
>> always get an error if I start a match with a conditional.
> 
> Not at all.  The bug was that a patterm like:
> 
>  @depends on patch@
>  expression x;
>  @@
>  - IS_ERR(x)
>  + IS_ERR_OR_NULL(x)
>    || ...
>  - || x == NULL
> 
> thought that it should be applied in two ways, giving an error about a
> double transformation of the IS_ERR call.
> 
> Could you reproduce the example that caused problems?

Hm, I can reproduce it anymore, even with my original patch, must have been
caused by some other error I had in the semantic patch at that time.

- Lars
