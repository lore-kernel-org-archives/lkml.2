Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0KIWNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:13:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34602 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0KIWNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mdj9WYtBSZ5kpShAosnmdEzWsr2JkaY06Bh5pDYsvpL3jt8uAOqhHy6XCNemdj7Z8w
         OXYtBsXq6t0fiABXbeYt/HP6BU+3i4/HdIrNa78b7+DJMR5YbH3+Vf+E3UJeCu5MqRQT
         RIorBdz9B/kuHv3lteXxujHB/lPf6neEEcIaA=
MIME-Version: 1.0
In-Reply-To: <20101109183208.GG9264@atomide.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
	<20101109173536.GE9264@atomide.com>
	<AANLkTinLORQ7Hyn7nqkNZhRbP8iTGRfAXibgY2VeZTPq@mail.gmail.com>
	<20101109183208.GG9264@atomide.com>
Date: Wed, 10 Nov 2010 00:13:32 +0200
Message-ID: <AANLkTikoUiPe1o7OH07ZWzr+9dj-YZ5hEKiqcNun1wNZ@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 8:32 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Guzman Lugo, Fernando <fernando.lugo@ti.com> [101109 09:43]:
>> On Tue, Nov 9, 2010 at 11:35 AM, Tony Lindgren <tony@atomide.com> wrote:
>> > * Guzman Lugo, Fernando <fernando.lugo@ti.com> [101109 08:36]:
>> >>
>> >> tidspbridge iommu change are working fine all the patches and few fixes after
>> >> that are alredy sent. what breaks tidspbridge, is the unmerged
>> >> dependencies in linux omap tree, specifically the iommu module patches
>> >> and the SG patch.
>> >
>> > Care to post a series of the missing patches listed above?
>>
>> Here are the missing patches:
>>
>> Fernando Guzman Lugo (4):
>>   iovmm: no gap checking for fixed address
>>   iovmm: add superpages support to fixed da address
>>   iovmm: replace __iounmap with omap_iounmap
>>   iommu: create new api to set valid da range
>
> Yeah this is stuff for Hiroshi to look at and queue for
> 2.6.28. No way we can merge these now.

Right, and he hasn't ack'ed them yet. So there's a chance they don't
get into 2.6.38 either.

>> and
>>   scatterlist: define SG chain for arm architecture
>
> And this we need to test carefully it's not something we
> can just merge.
>
> Has this been tested to work with omap MMC drivers?
>
> I'm not at all convinced the drivers can deal with
> chained SG lists.. This may not show up with light
> testing, the SG lists can be very small in most cases.
>
> So this would have to be tested to make sure the
> the chained SG list handled properly. The same goes
> for other omap drivers that may be using SG.

And the change doesn't affect OMAP only, it's for all ARM platforms.

The proposal from Russell was to do it only on OMAP, but I haven't
seen a patch that does that yet. Hopefully this would go into 2.6.38,
but again, it might not.

-- 
Felipe Contreras
