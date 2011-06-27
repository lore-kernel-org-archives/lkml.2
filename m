Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1F0RWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:22:19 -0400
Received: from c60.cesmail.net ([216.154.195.49]:61589 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1F0RWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:22:14 -0400
Message-ID: <4E08BC44.3020105@gnu.org>
Date: Mon, 27 Jun 2011 13:22:12 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>	 <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>	 <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>	 <BANLkTikVtWe0jB_jLeP1YZTEKSYA97gdqQ@mail.gmail.com>	 <4E08B4AA.409@broadcom.com> (sfid-20110627_185027_507290_BCE834F5) <1309193844.3911.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1309193844.3911.27.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 12:57 PM, Johannes Berg wrote:

> Yeah, good rule. Consider if you have a.h, b.h and z.c, z.c needs b.h
> but not a.h, and now b.h includes a.h ("for convenience") -- changing
> a.h would needlessly recompile z.c. Now, changing slab.h will probably
> recompile everything anyway, but still...

In my configuration after touching slab.h and recompilation:

$ find -name '*.o' -newer ../linux3/include/linux/slab.h |wc -l
1508
$ find -name '*.o' |wc -l
1928

78% object files were recompiled, 22% were no recompiled.  Careful use 
of includes does save time.

-- 
Regards,
Pavel Roskin
