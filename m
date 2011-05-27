Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1E0Ss6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:48:58 -0400
Received: from mail.lang.hm ([64.81.33.126]:42983 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1E0Ss5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:48:57 -0400
Date: Fri, 27 May 2011 11:48:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
In-Reply-To: <20110527181724.GA6485@elte.hu>
Message-ID: <alpine.DEB.2.02.1105271141020.30828@asgard.lang.hm>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu> <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com> <20110527181724.GA6485@elte.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Ingo Molnar wrote:

I don't think these two new images are as important as you are tagging 
them. I would put them down with the 'protect the system from root' type 
of issues.

> - Boot time dynamic randomization allows randomization of 'mass
>   install' systems, where the same image is used, to still be
>   randomized: for example a million phones all with the same Flash
>   ROM image and no 'install' performed at all on them.
>
>   With static randomization these systems will all have the same
>   kernel addresses.

there is already a need to be able to customize these systems on an 
individual system basis (think SSL certs or ssh keys for example)

yes, this makes it a little more difficult than just 'drop this image bit 
for bit on the system', but it's not that hard to setup a 'the first time 
you boot do this stuff then reboot' step, and that step can do the 
'install time' stuff.

> - Boot time dynamic randomization allows read-only systems to still
>   be randomized: for example internet cafes that use some popular
>   pre-packaged kiosk-mode live-DVD. They probably wont bother
>   randomizing and relinking the ISOs per machine and burning per
>   machine DVDs ...

this matters a little bit more because a script to create a custom DVD 
image on the fly is more difficult.

however, I think this is a significantly less important target, 
specifically because these are read-only system images.

but if someone really cares about this, they just need to create a stack 
of slightly different DVDs. if this can be batched up and automated it's 
not that big a deal. the DVDs don't really need to be per-machine, just a 
variety of them.

David Lang
