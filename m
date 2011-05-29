Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1E2SUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:20:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58914 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab1E2SUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:20:43 -0400
Message-ID: <4DE28E1E.60207@zytor.com>
Date: Sun, 29 May 2011 11:19:10 -0700
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
References: <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <4DDFE52D.4070308@zytor.com> <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com> <20110528121820.GB12059@elte.hu> <4DE19DC3.7090106@zytor.com> <20110529124702.GE26627@elte.hu>
In-Reply-To: <20110529124702.GE26627@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 05:47 AM, Ingo Molnar wrote:
> 
> Do you mean we'd not start at a 2MB boundary and thus would waste on 
> average an about 0.125 worth of huge-TLB cache entry?
> 
> That does not look like a very big issue to me - but maybe i'm 
> missing something and you mean something else.
> 

The problem is that because of the misalignment, and whatever falls on
the other side of that memory boundary we might end up having to
fracture the 2 MB page into 4K pages.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

