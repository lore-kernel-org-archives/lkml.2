Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab1DASW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:22:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60170 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593Ab1DASWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110331153010.GD2704@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl> <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de> <20110331141650.GB2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
 <20110331150939.GC2704@sortiz-mobl> <99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
 <20110331153010.GD2704@sortiz-mobl>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Fri, 1 Apr 2011 15:19:30 -0300
Message-ID: <AANLkTikjTAFrhS7_P+KJ-r-33K6fW2+63OnLhjXE-u0k@mail.gmail.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Waldemar.Rymarkiewicz@tieto.com, arnd@arndb.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk,
        Sebastian.Chlad@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, Mar 31, 2011 at 12:30 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Thu, Mar 31, 2011 at 06:24:50PM +0300, Waldemar.Rymarkiewicz@tieto.com wrote:
>> Hi Samuel,
>>
>> >That's the Bluetooth approach, and it works just fine as well.
>> >However, the netlink option for sending commands and receiving
>> >answers to/from a subsystem sounds more appropriate, at least to me.
>>
>> I haven't used netlink in practice, so just wondering why netlink. I assume, then, it's more suitable :)
>>
> Have a look at the wireless nl80211.c implementation. It's a good example for
> that sort of usage.

We are finalizing a NFC stack prototype and we decided to use generic
netlink. But during the implementation we found a disadvantage of this
approach.

While implementing data_exchange through netlink, it was not possible
to avoid memcpy as the skbuff coming from netlink can contain more
than one message.

We didn't find any implementation that uses netlink to exchage data.
As in the nl80211, the netlink is used only for control commands.

We plan to publish for comments this prototype early next week. Then
we plan to implement a version using AF_NFC.

Regards,

Aloisio Almeida Jr
INdT - Instituto Nokia de Tecnologia

> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
