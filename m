Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0ETAKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0ETAKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:10:08 -0400
Message-ID: <4BF47DAF.5040409@zytor.com>
Date: Wed, 19 May 2010 17:09:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
CC: Yinghai <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved
 by 	BIOS
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com>	 <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>	 <4BF46D9B.4090806@zytor.com> <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
In-Reply-To: <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 05:01 PM, Mathieu Rondonneau wrote:
> it' s not in ISA space.
> once loading the NVIDIA driver, the warnign oops shows up.
> 4K starting at 0x9f800 (i.e. to 0xa007ff) overlap with the ISA space
> (starting at 0xa0000).
> 
> When I don' t load the driver, no oops.
> So I am assuming nvidia driver request 4K of memory, that happens to
> be available in the bios area.
> 
> I think that there is a check missing somewhere to report that
> available RAM buffer is already reserved (by BIOS) so we need to get
> it from somewhere else.
> 
> Does it make sense?
> -Mathieu

No.

The top page (0x9f000) is generally also reserved... there is pretty
much always BIOS data structures there.

It sounds like the Nvidia driver is trying to map those, and doing it
incorrectly.  -ENVIDIA.

	-hpa
