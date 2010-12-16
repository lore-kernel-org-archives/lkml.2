Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0LPX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:28:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57789 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LPX2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rSYDAIfjacUhRFqkrx7pdki3KSC3ovjn6Umg4NJF7PnRdiyu3rQ4gd6P/vsNbt7LRh
         PE/RtVzshHxAMGoxGJzg0MU2cSLADKqXPswBKKwKubh/th0y7jjl0yjhesOZkzjdZgKZ
         GhT4nyByJszgvP1uREICYQ34INDMjD66uQXwM=
MIME-Version: 1.0
In-Reply-To: <20101216190207.GC6767@lba0869738>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
	<20101216172531.GG29435@lba0869738>
	<20101216173737.GA6767@lba0869738>
	<201012161843.48262.arnd@arndb.de>
	<20101216190207.GC6767@lba0869738>
Date: Fri, 17 Dec 2010 09:28:07 +1000
Message-ID: <AANLkTikZwm45Mkj_A=zzULeGBuYpLyP9N1bSJSFWegWV@mail.gmail.com>
Subject: Re: [PATCH 0/9] TI DMM-TILER driver
From: Dave Airlie <airlied@gmail.com>
To: David Sin <davidsin@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 5:02 AM, David Sin <davidsin@ti.com> wrote:
> On Thu, Dec 16, 2010 at 06:43:48PM +0100, Arnd Bergmann wrote:
>> As far as I can tell, both DMM and GEM at a high level manage objects
>> in video memory. The IOMMU that you have on the Omap hardware seems
>> to resemble the GART that sits between PC-style video cards and main
>> memory.
>>
>> I don't know any details, but google quickly finds
>> http://lwn.net/Articles/283798/ with a description of the
>> initial GEM design. My main thought when looking over the
>> DMM code was that this should not be tied too closely to a
>> specific hardware, and GEM seems to be an existing abstraction
>> that may fit what you need.
>>
>>       Arnd
> Thanks for the pointer, Arnd.  I also found a nice readme file in
> the gpu/drm directory, which points to a wiki and source code.
> I'll read into this and get back to you.

I get the impression with the ARM graphics, that you just have a lot
of separate drivers for separate IP blocks all providing some misc
random interfaces to userspace where some binary driver binds all the
functionality together into a useful whole, which seems like a really
bad design.

Generally on x86, the tiling hw is part of the GPU and is exposed as
part of a coherent GPU driver.

I'm just wonder what the use-cases for this tiler are and what open
apps can use it for?

Dave.
