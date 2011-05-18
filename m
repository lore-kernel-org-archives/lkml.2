Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1ERJGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:06:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61362 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1ERJGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mHCizrZkjitGY6IF8Hpw31HwBotgLTWQ5b3p427P2ZaSjvQx7jm2xiV1WTtDg2MHlv
         nd7596J2zMVhzxK/qrFrczGzNfXBtH0rf86fvQJx9fcoBNNeZLpBoJsZjJC6PPSloXJw
         l0bbHQMBhHfY+xrASIOAqaspSItLzPNeDbPt8=
MIME-Version: 1.0
In-Reply-To: <1305675865.10756.63.camel@localhost.localdomain>
References: <1305574128.3456.23.camel@localhost.localdomain>
 <1305574518.2885.25.camel@bwh-desktop> <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain> <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
 <1305671318.10756.49.camel@localhost.localdomain> <BANLkTik6aqP5BVrQNFKrnU3v=KA9ip1RoA@mail.gmail.com>
 <1305675865.10756.63.camel@localhost.localdomain>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 18 May 2011 11:06:00 +0200
Message-ID: <BANLkTinvQBnhT1sUgHWhR5_3QDBTrjbNcw@mail.gmail.com>
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in netdevice
To: Shirley Ma <mashirle@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 maja 2011 01:44 u¿ytkownik Shirley Ma <mashirle@us.ibm.com> napisa³:
> On Wed, 2011-05-18 at 00:58 +0200, Micha³ Miros³aw wrote:
>> W dniu 18 maja 2011 00:28 u¿ytkownik Shirley Ma <mashirle@us.ibm.com>
>> napisa³:
>> > On Tue, 2011-05-17 at 23:48 +0200, Micha³ Miros³aw wrote:
>> >> 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
>> >> > Looks like to use a new flag requires more time/work. I am
>> thinking
>> >> > whether we can just use HIGHDMA flag to enable zero-copy in
>> macvtap
>> >> to
>> >> > avoid the new flag for now since mavctap uses real NICs as lower
>> >> device?
>> >>
>> >> Is there any other restriction besides requiring driver to not
>> recycle
>> >> the skb? Are there any drivers that recycle TX skbs?
>> > Not more other restrictions, skb clone is OK. pskb_expand_head()
>> looks
>> > OK to me from code review.
>>
>> > Currently there is no drivers recycle TX skbs.
>>
>> So why do you require the target device to have some flags at all?
> We could use macvtap to check lower device HIGHDMA to enable zero-copy,
> but I am not sure whether it is sufficient. If it's sufficient then we
> don't need to use a new flag here. To be safe, it's better to use a new
> flag to enable each device who can pass zero-copy test.

>> Do I understand correctly, that this zero-copy feature is about
>> packets received from VMs?
> Yes, packets sent from VMs, and received in local host for TX zero-copy
> here.

What is the zero-copy test? On some arches the HIGHDMA is not needed
at all so might be not enabled on anything. It looks like the correct
test would be per-packet check of !illegal_highdma() or maybe
NETIF_F_SG as returned from harmonize_features(). For virtual devices
or other software forwarding this might lead to skb_linearize() in
some cases, but is it that bad?

Best Regards,
Micha³ Miros³aw
