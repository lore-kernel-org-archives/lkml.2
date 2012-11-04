Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2KDP5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:57:40 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:16118 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065Ab2KDP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:57:36 -0500
X-IronPort-AV: E=Sophos;i="4.80,710,1344204000"; 
   d="scan'208";a="180070721"
Date: Sun, 4 Nov 2012 16:57:33 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Sasha Levin <levinsasha928@gmail.com>
cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/8] drop if around WARN_ON
In-Reply-To: <CA+1xoqd-UQXg0nuE1t5ayYY1Ow81er2mHUFUow=mfcwzkCPW5A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1211041656580.1960@localhost6.localdomain6>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr> <CA+1xoqd-UQXg0nuE1t5ayYY1Ow81er2mHUFUow=mfcwzkCPW5A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012, Sasha Levin wrote:

> Hi Julia,
>
> On Sat, Nov 3, 2012 at 4:30 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>> These patches convert a conditional with a simple test expression and a
>> then branch that only calls WARN_ON(1) to just a call to WARN_ON, which
>> will test the condition.
>>
>> // <smpl>
>> @@
>> expression e;
>> @@
>>
>> (
>> if(<+...e(...)...+>) WARN_ON(1);
>> |
>> - if (e) WARN_ON(1);
>> + WARN_ON(e);
>> )// </smpl>
>
> So this deals with WARN_ON(), are you considering doing the same for
> the rest of it's friends?

I tried WARN_ON_ONCE, but the pattern never occurred.  Are there others 
that are worth trying?

thanks,
julia
