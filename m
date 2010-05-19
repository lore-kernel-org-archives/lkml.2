Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0ESXBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:01:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54406 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab0ESXBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:01:35 -0400
Message-ID: <4BF46D9B.4090806@zytor.com>
Date: Wed, 19 May 2010 16:00:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
CC: Yinghai <yinghai.lu@oracle.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved
 by 	BIOS
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com> <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>
In-Reply-To: <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 03:58 PM, Mathieu Rondonneau wrote:
> Thanks for the feedback.
> 
> No, I don' t see any changes in the /proc/iomem.
> 
> I am trying to prevent a ioremap of a 4K size on a non aligned 4K
> address that is below the ISA_START_ADDRESS.
> 
> The problem generates a oops about overlapping.
> I have a fix which instruct to not to do any re-map if the section
> name is "reserved".
> Which is not really clean.
> I am looking for a clean way to tell the ioremap function to not remap
> bios reserved memory.
> That' s why I thought the e820 would be a good start.
> 
> I will continue looking into this. It does not crash the systems. A
> warning generates the oops.
> 

Why are you mapping a fixed-address in ISA space to begin with?

Requests to a fixed address (as opposed to dynamic allocation) have to
be granted even in reserved space -- after all, that's what the address
might be reserved for!

	-hpa
