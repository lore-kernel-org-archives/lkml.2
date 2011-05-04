Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1EDQGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:06:55 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53555 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab1EDQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:06:54 -0400
X-Auth-Info: Vkn3xecMoPtp5rYqwKEzm8Yqu6QVdqeynHlkcLBBqT0=
Message-ID: <4DC17A31.8070409@grandegger.com>
Date: Wed, 04 May 2011 18:09:21 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<201104271525.28512.arnd@arndb.de>	<15AD189F851849F69A011B6F4D1DDB6C@subhasishg>	<201105041511.54095.arnd@arndb.de>	<4DC163D7.9010309@grandegger.com> <20110504155750.GC322@e-circ.dyndns.org>
In-Reply-To: <20110504155750.GC322@e-circ.dyndns.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

On 05/04/2011 05:57 PM, Kurt Van Dijck wrote:
>>
>>> How hard would it be to implement that feature in Socket CAN?
>>
>> CAN controllers usually provide some kind of hardware CAN id filtering,
>> but in a very hardware dependent way. A generic interface may be able to
>> handle the PRUSS restrictions as well. CAN devices are usually
>> configured through the netlink interface. e.g.
>>
>>   $ ip link set can0 up type can bitrate 125000
>>
>> and such a common interface would be netlink based as well.
> ack.
>>
>>> Is that something that Subhasish or someone else could to as a prerequisite
>>> to merging the driver?
>>
>> Any ideas on how to handle hardware filtering in a generic way are
>> welcome. I will try to come up with a proposal sooner than later.
> 
> When doing so, I'd vote for an unlimited(by software) list of hardware filters (id/mask).
> The hardware must abort when no more filters are available.

Sounds good and not even to complicated. For the SJA1000 we would just
allow to set the global mask.

> I think that when using hardware filters, knowing the actual device
> with it's amount of hardware filters is the least of your problems.
> Userspace applications that suddenly stop working properly due to
> hw filters (i.e. some traffic not coming in anymore) will be a major
> source of bugreports.

Well, hardware filtering will be off by default and must explicitly be
set by the user, like for the bitrate setting.

Wolfgang.

