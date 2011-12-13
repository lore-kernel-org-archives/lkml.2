Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1LMJ4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:56:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4814 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1LMJ4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:56:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 13 Dec 2011 01:56:34 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "bunk@kernel.org" <bunk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 13 Dec 2011 15:26:28 +0530
Subject: RE: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Thread-Topic: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Thread-Index: AcypZpsvjeKnR7WNTOCwkaiYdeDcxwQFroPA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DCD652AF0@BGMAIL02.nvidia.com>
References: <1321420292-26970-1-git-send-email-vbyravarasu@nvidia.com>
 <20111122143214.5cc8f17e.akpm@linux-foundation.org>
In-Reply-To: <20111122143214.5cc8f17e.akpm@linux-foundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can someone please approve this change or send comments in case of any more objections?

Thanks,
Venu


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, November 23, 2011 4:02 AM
> To: Venu Byravarasu
> Cc: torvalds@linux-foundation.org; a.zummo@towertech.it; bunk@kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
> 
> On Wed, 16 Nov 2011 10:41:32 +0530
> vbyravarasu@nvidia.com wrote:
> 
> > From: venu byravarasu <vbyravarasu@nvidia.com>
> >
> > Current implementation of bin2bcd allows any value
> > between 0x0 to 0xF to be stored in the most significant
> > nibble of its returned value, against to the BCD limits
> > of 0 - 9. Hence fixing it.
> >
> > e.g. say val passed to bin2bcd is 123.
> > In that case the expected value to be returned by
> > this function is 0x23.
> > However, without the fix being added, it would
> > return 0xC3.
> >
> 
> I'm not sure that I agree.  Passing 123 to bin2bcd() is a bug, isn't
> it?  We want to know about bugs so we can fix them, and quietly repairing
> thngs in callees prevents that.

