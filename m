Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1E2BPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 21:15:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47148 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1E2BPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 21:15:04 -0400
Message-ID: <4DE19DC3.7090106@zytor.com>
Date: Sat, 28 May 2011 18:13:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <4DDFE52D.4070308@zytor.com> <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com> <20110528121820.GB12059@elte.hu>
In-Reply-To: <20110528121820.GB12059@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2011 05:18 AM, Ingo Molnar wrote:
> 
> Having half a megabyte of '__init buffer' at the beginning or end of 
> the kernel image is no big deal, it's more than enough for good 
> randomization and makes the whole thing image-loader invariant: we 
> can freely shift the 'real' kernel image within this larger boundary 
> without consulting RAM maps.
> 

Sure, but you're also blowing any attempt at PMD alignment to kingdom come.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

