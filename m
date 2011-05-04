Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1EDObg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:31:36 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:40715 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1EDObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:31:35 -0400
X-Auth-Info: b6zKnNy2oyuLY2yR5oVwMZfna3ZK5CW0dS6Zw9yt94s=
Message-ID: <4DC163D7.9010309@grandegger.com>
Date: Wed, 04 May 2011 16:33:59 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201104271525.28512.arnd@arndb.de> <15AD189F851849F69A011B6F4D1DDB6C@subhasishg> <201105041511.54095.arnd@arndb.de>
In-Reply-To: <201105041511.54095.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 05/04/2011 03:11 PM, Arnd Bergmann wrote:
> On Wednesday 04 May 2011, Subhasish Ghosh wrote:
>> CAN requires mail box IDs to be programmed in. But, the socket
>> CAN subsystem supports only software filtering of the mail box IDs.
>>
>> So, the mail box IDs programmed into socket CAN during initialization
>> does not propagate into the hardware. This is planned to be a future
>> implementation in Socket CAN.
>>
>> In our case, we support hardware filtering, to work around with this,
>> Wolfgang (Socket CAN owner) suggested that we implement
>> this using sysfs.
>>
>> These setting are not for debugging, but to program the mail box IDs
>> into the hardware. 
> 
> Ok, I see. Can you point me to that discussion?
> 
> Wolfgang, I'm a bit worried by the API being split between sockets and sysfs.
> The problem is that once the sysfs API is established, users will start
> relying on it, and you can no longer migrate away from it, even when
> a later version of the Socket CAN also supports setting through a different
> interface. What is the current interface to set mail box IDs in software?

Note that this CAN controller is *very* special. It cannot handle all
CAN id's due to a lack or resources. The PRUSS firmware is able to
manage just up to 8 different CAN identifiers out of the usual 4096
(12-bit) or even more for the extended CAN ids using 29 bits. There is
no other CAN controller with such rather serious limitations and
therefore there exists also no appropriate interface. I think using
sysfs is OK for such device-specific parameters, at least for the time
being.

> How hard would it be to implement that feature in Socket CAN?

CAN controllers usually provide some kind of hardware CAN id filtering,
but in a very hardware dependent way. A generic interface may be able to
handle the PRUSS restrictions as well. CAN devices are usually
configured through the netlink interface. e.g.

  $ ip link set can0 up type can bitrate 125000

and such a common interface would be netlink based as well.

> Is that something that Subhasish or someone else could to as a prerequisite
> to merging the driver?

Any ideas on how to handle hardware filtering in a generic way are
welcome. I will try to come up with a proposal sooner than later.

Wolfgang.
