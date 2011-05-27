Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1E0RHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:07:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46587 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1E0RHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:07:33 -0400
Message-ID: <4DDFDA22.205@zytor.com>
Date: Fri, 27 May 2011 10:06:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu>
In-Reply-To: <20110527170045.GB4356@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 10:00 AM, Ingo Molnar wrote:
> 
> The problem with your relinking solution is that a local attacker can 
> easily figure out where the kernel is. So this does not protect 
> against the more common break-in scenario.
> 

There is another issue with it: it doesn't actually solve the real
problem other than suspend/resume, which is that the relocation agent
needs to understand what the memory space looks like at the time of boot.

I think something else we will need for this to be possible is initramfs
decoding directly from highmem, since the hack we're currently using to
deal with an initramfs/initrd located partly in highmem will break.

	-hpa
