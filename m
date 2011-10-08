Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1JHHWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:22:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1JHHWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111007092445.4f097ed9@nehalam.linuxnetplumber.net>
References: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com> <20111007092445.4f097ed9@nehalam.linuxnetplumber.net>
From: Mihai Maruseac <mihai.maruseac@gmail.com>
Date: Sat, 8 Oct 2011 10:22:26 +0300
Message-ID: <CAOMsUMKcd-Xg0uezvknBFLCYx7U9PuKpgfHdKw8vjVvmbH6KoQ@mail.gmail.com>
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops.
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 7:24 PM, Stephen Hemminger <shemminger@vyatta.com> wrote:
> On Fri,  7 Oct 2011 18:20:49 +0300
> Mihai Maruseac <mihai.maruseac@gmail.com> wrote:
>
>> Instead of using the dev->next chain and trying to resync at each call to
>> dev_seq_start, use this hash and store bucket number and bucket offset in
>> seq->private field.
>>
>> Tests revealed the following results for ifconfig > /dev/null
>>       * 1000 interfaces:
>>               * 0.114s without patch
>>               * 0.020s with patch
>>       * 3000 interfaces:
>>               * 0.489s without patch
>>               * 0.048s with patch
>>       * 5000 interfaces:
>>               * 1.363s without patch
>>               * 0.131s with patch
>>
>> As one can notice the improvement is of 1 order of magnitude.
>
> Good idea,
> This will change the ordering of entries in /proc which may upset
> some program, not a critical flaw but worth noting.
>
> Rather than recording the bucket and offset of last entry, another
> alternative would be to just record the ifindex.
>
> Also ifconfig is considered deprecated and replaced by ip commands
> for general use.
>

Thanks,
This is a patch from a series of improvements to both the ifconfig and
ip commands. The ip part will come later, after being properly
implemented and tested.

-- 
Mihai
