Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2F2O57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:57:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45718 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2F2O56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <1340979030.3070.216.camel@sauron.fi.intel.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
 <1340894351.3070.121.camel@sauron.fi.intel.com> <CACQ1gAjLdR-ZRUS6gxMrJzVpRdvdMK2JRceyiFmeSq-FQkZbZg@mail.gmail.com>
 <1340900549.3070.130.camel@sauron.fi.intel.com> <CACQ1gAgGbYvTO=_vVW11Ru9OXpra7oiJinbpX=DBiOHmoUtA8g@mail.gmail.com>
 <1340979030.3070.216.camel@sauron.fi.intel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 29 Jun 2012 16:57:42 +0200
Message-ID: <CACQ1gAgF8pUZJUHOOpohhNSC54X+Y72YymupxOMxnpJ8wgss+g@mail.gmail.com>
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in Kconfig
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/29 Artem Bityutskiy <dedekind1@gmail.com>:
>> I was thinking that instead of giving to ubiattach the MBB, we could
>> give it the MBB percentage (maximum bad blocks percentage of the whole
>> flash device).
>> From this % and the whole flash size, we get the MBB number, and set
>> beb_rsvd_level for each MTD part.
>
> Well, I thought that it may be not flexible enough for some people,
> because you cannot give 1.5%, since flaoting-point arithmetic in the
> kernel is not used.
So there's 2 ways to bypass that :
- use per-1024 instead of percent => the default value would be 20.
- let ubiattach do the conversion from MBB% to MBB
I like the 1st one because it gives a number close to what we have in
the datasheets.
What do you think ?



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
