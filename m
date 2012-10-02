Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2JBGsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:48:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47186 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2JBGsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com>
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
	<20120928121917.GF5368@mwanda>
	<1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	<20120929072527.GA13767@mwanda>
	<1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	<20121001150913.GC13767@mwanda>
	<1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	<1349119899.10330.53.camel@jlt4.sipsolutions.net>
	<1349132818.58475.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Tue, 2 Oct 2012 08:48:07 +0200
Message-ID: <CAKoUAr=c8MTc8rvBnKKNJ09LMjvhi=OLzvHvdv6gKG6T2vda=w@mail.gmail.com>
Subject: Re: How do I get mac80211 debugfs?
From: Rami Rosen <roszenrami@gmail.com>
To: Kevin Cruz <skate_ops@yahoo.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Intel Wireless <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could it be that debugfs is not mounted on your filesystem ?

In case
mount | grep debugfs
returns nothing,
you can run:

mount -t debugfs none_debugs /sys/kernel/debug
and try again.

Also make sure that
CONFIG_MAC80211_DEBUGFS is set

location is:
    -> Networking support (NET [=y])                                    │
        -> Wireless (WIRELESS [=y])

Regards,
Rami Rosen


On Tue, Oct 2, 2012 at 1:06 AM, Kevin Cruz <skate_ops@yahoo.com> wrote:
> Hey Johannes,
>     None of this should be too much of an effort for me. Thankfully I
> don't find terminals to be daunting.
>
>> Yeah ... we saw this in the lab at some point, but somehow we couldn't
>> reproduce it again later. The issue is that we stop the queues, and
>> never restart them, and if it's the same issue then it's definitely the
>> driver's fault.
>
>> To confirm, when you get this, can you please do
>
>> sudo cat /sys/kernel/debug/ieee80211/phy*/queues
>
>> (assuming you have mac80211 debugfs compiled)
>
> So I tried that but all I got back was:
>
>     cat: /sys/kernel/debug/ieee80211/phy*/queues: No such file or directory
>
> so I'm assuming it's because I must not have mac80211 debugfs.  So how
> do I get it?
>
> Thanks, Kevin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
