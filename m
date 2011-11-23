Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab1KWDwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:52:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9624 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab1KWDwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:52:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 22 Nov 2011 19:52:16 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "bunk@kernel.org" <bunk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 09:22:11 +0530
Subject: RE: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Thread-Topic: [PATCH] bcd: limit bin2bcd input value to lie between 0-99
Thread-Index: AcypZpsvjeKnR7WNTOCwkaiYdeDcxwAK1WEg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DCAB86F5D@BGMAIL02.nvidia.com>
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

As bin2bcd is having "unsigned val" as parameter, I do not understand why passing 123 is a bug.
123 that I mentioned here in my example is a decimal value, which is very well within unsigned char limits.
Even any value beyond 99 would create this problem, as the values are not really getting stored as BCD, where each nibble value is to be limited to stay within 0 to 9.
Probably it would be better to change the param of "bin2bcd" from "unsigned val" to "unsigned char" itself.  
