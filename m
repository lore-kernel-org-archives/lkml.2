Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2IQJ7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:59:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44078 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2IQJ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <201209171113.45276.andres@anarazel.de>
References: <201209170118.25955.andres@anarazel.de>
	<CAH3drwZ-Wc=PViwuj=PgcOrsZBfvozdZRK=Q2Q-uJFktSbGQcw@mail.gmail.com>
	<201209171113.45276.andres@anarazel.de>
Date: Mon, 17 Sep 2012 05:59:34 -0400
Message-ID: <CAH3drwanacWd_b_ZF3eNiDSijuG2tXgjt8BsgYYUb+pjAV09VA@mail.gmail.com>
Subject: Re: Excessive kernel time inside ttm when scrolling on a r700 in a
 multimonitor setup
From: Jerome Glisse <j.glisse@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 5:13 AM, Andres Freund <andres@anarazel.de> wrote:
> On Monday, September 17, 2012 10:47:10 AM Jerome Glisse wrote:
>> On Sun, Sep 16, 2012 at 7:18 PM, Andres Freund <andres@anarazel.de> wrote:
>> > Hi everyone,
>> >
>> > In several gui programs, most notably and reproducably, I can trivially
>> > make Xorg spend the whole cpu time in the kernel. It might be an Xorg
>> > bug, but from my untrained gut feeling it doesn't look that way.
>> >
>> > Anything more you need than whats already in the email?
>>
>> > Here are some details:
>> Is it an AGP card ? It looks like it's the PAT update that kills perf
>> for you, not much we can do, the pool allocator is probably starve.
> If you mean AGP as in the old strange graphics bus, no. Its a pcie card.
>
> If that helps you, more detailedly the card is a: SAPPHIRE Radeon HD6870
>
> Unfortunately the manufacturers page is remarkably devoid of details...:
> http://www.sapphiretech.com/presentation/product/?cid=1&gid=3&sgid=1037&lid=1&pid=1270&leg=0
>
> Greetings,
>
> Andres

Well, then the issue is that it tries to allocate write combined pages
on PCIE which should not happen. I don't see how in the code you endup
in that path unless drm_pci_device_is_agp return true for some
reasons.

Cheers,
Jerome
