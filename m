Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0JSUvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:51:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0JSUvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9G9/wxzYHZ2KpqRwIvOYAhaCwjP5jvENkxjlqKX4UXqZQVVhUyIIlycu5VWDfJg4x
         TfLETd5vgcYf93fLul0Gm57C3qRqcEeTAv+j2uQlc5/M1iVBQrzQ6wsfx7G4UTrAgYiH
         mXOrlOQpjv1hGfo7iYoHy6Wlyx2HkuwWy8gGk=
MIME-Version: 1.0
In-Reply-To: <201010191526.01887.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
	<AANLkTi=oAeuz8ZxcOMpf=3MVY=WMt0BwHiGCUxO7OAEV@mail.gmail.com>
	<201010190926.54635.arnd@arndb.de>
	<201010191526.01887.arnd@arndb.de>
Date: Wed, 20 Oct 2010 06:50:58 +1000
Message-ID: <AANLkTinw=Wzh2Ucj6zKSoqC8J3Yq9xDr3mKMUB7K6Yyo@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
        codalist@telemann.coda.cs.cmu.edu, autofs@linux.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Jan Harkes <jaharkes@cs.cmu.edu>, netdev@vger.kernel.org,
        Anders Larsen <al@alarsen.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 October 2010, Arnd Bergmann wrote:
>> On Tuesday 19 October 2010 06:52:32 Dave Airlie wrote:
>> > > I might be able to find some hardware still lying around here that uses an
>> > > i810. Not sure unless I go hunting it. But I get the impression that if
>> > > the kernel is a single-CPU kernel there is not any problem anyway? Don't
>> > > distros offer a non-smp kernel as an installation option in case the user
>> > > needs it? So in reality how big a problem is this?
>> >
>> > Not anymore, which is my old point of making a fuss. Nowadays in the
>> > modern distro world, we supply a single kernel that can at runtime
>> > decide if its running on SMP or UP and rewrite the text section
>> > appropriately with locks etc. Its like magic, and something like
>> > marking drivers as BROKEN_ON_SMP at compile time is really wrong when
>> > what you want now is a runtime warning if someone tries to hotplug a
>> > CPU with a known iffy driver loaded or if someone tries to load the
>> > driver when we are already in SMP mode.
>>
>> We could make the driver run-time non-SMP by adding
>>
>>       if (num_present_cpus() > 1) {
>>               pr_err("i810 no longer supports SMP\n");
>>               return -EINVAL;
>>       }
>>
>> to the init function. That would cover the vast majority of the
>> users of i810 hardware, I guess.
>
> Some research showed that Intel never support i810/i815 SMP setups,
> but there was indeed one company (http://www.acorpusa.com at the time,
> now owned by a domain squatter) that made i815E based dual Pentium-III
> boards like this one: http://cgi.ebay.com/280319795096

Also that board has no on-board GPU enabled i815EP (P means no on-board GPU).

So I think i810 is fine.
>
> The first person that can send me an authentic log file showing the
> use of X.org with DRM on a 2.6.35 kernel with two processors on that
> mainboard dated today or earlier gets a free upgrade to an AGP graphics
> card of comparable or better 3D performance from me. Please include
> the story how why you are running this machine with a new kernel.
>
> i830 is harder, apparently some i865G boards support Pentium 4 with HT
> and even later dual-core processors.

Also hyper-threaded 845G boards, however I'm happy to start a proper
deprecation procedure on the i830 ABI,
Its been a few years since a distro shipped with it, I think even
RHEL5 has the i915 driver enabled, so we are
probably talking RHEL4 era.

Dave.
