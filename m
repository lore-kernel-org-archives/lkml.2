Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0GaJnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 05:43:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52724 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0GaJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 05:43:07 -0400
Message-ID: <4C53F01A.8090205@cs.helsinki.fi>
Date: Sat, 31 Jul 2010 12:42:50 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@gmail.com>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>	<4C505F86.7050509@cs.helsinki.fi>	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>	<AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>	<4C519A6E.8000002@cs.helsinki.fi>	<AANLkTik4oyv4edZ6dyKiA59C9TSHWn2grQqTh30MRmC=@mail.gmail.com>	<AANLkTinAtDQoB9VhX4J=HJSkYTM8ERBDXG8ZYng1SGYL@mail.gmail.com> <AANLkTi=+_bSNY3pnowGmU-NEVzL7VWYeGhT44y7SL3L7@mail.gmail.com>
In-Reply-To: <AANLkTi=+_bSNY3pnowGmU-NEVzL7VWYeGhT44y7SL3L7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
>> Right. I guess the required earlylog buffer size would be smaller if
>> we initialized kmemleak earlier. Can we do that in mm_init() after
>> kmem_cache_init()?
> 
> Kmemleak uses kmem_cache_alloc() internally so we could initialise it
> as soon as kmem_cache_init() was called. But it's really strange the
> amount of early allocations that Daniel is getting. I've been happy so
> far with 400, usually with standard Ubuntu-like configs and some
> debugging turned on. Any idea what's causing these allocations?

No idea. I wonder if kmemleak can dump out the call-sites for the 
overflow case somehow to see what's going on?

			Pekka
