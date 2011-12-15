Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1LOE71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 23:59:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54323 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab1LOE7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 23:59:25 -0500
MIME-Version: 1.0
In-Reply-To: <4EE903CE.1010903@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	<1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	<4EDEAEB9.6020703@freescale.com>
	<1323724195.2297.11.camel@koala>
	<4EE66EFE.1050608@freescale.com>
	<1323724784.2297.20.camel@koala>
	<4EE6725C.3050706@freescale.com>
	<4EE6BC9B.4000602@freescale.com>
	<4EE8612C.9050104@freescale.com>
	<4EE903CE.1010903@freescale.com>
Date: Thu, 15 Dec 2011 12:59:24 +0800
X-Google-Sender-Auth: TFu7m9JkG2-NuWfjbHWwNaqGFd4
Message-ID: <CADRPPNRRXTWzBEvY=vhe9+v0b8Ntq8KNoaXFN8pQZGmMc-dJYw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Li Yang <leoli@freescale.com>
To: Scott Wood <scottwood@freescale.com>
Cc: LiuShuo <b35362@freescale.com>, dedekind1@gmail.com,
        shuo.liu@freescale.com, dwmw2@infradead.org,
        Artem.Bityutskiy@nokia.com, linux-mtd@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 4:15 AM, Scott Wood <scottwood@freescale.com> wrote:
> On 12/14/2011 02:41 AM, LiuShuo wrote:
>> 于 2011年12月13日 10:46, LiuShuo 写道:
>>> 于 2011年12月13日 05:30, Scott Wood 写道:
>>>> On 12/12/2011 03:19 PM, Artem Bityutskiy wrote:
>>>>> On Mon, 2011-12-12 at 15:15 -0600, Scott Wood wrote:
>>>>>> NAND chips come from the factory with bad blocks marked at a certain
>>>>>> offset into each page.  This offset is normally in the OOB area, but
>>>>>> since we change the layout from "4k data, 128 byte oob" to "2k
>>>>>> data, 64
>>>>>> byte oob, 2k data, 64 byte oob" the marker is no longer in the
>>>>>> oob.  On
>>>>>> first use we need to migrate the markers so that they are still in
>>>>>> the oob.
>>>>> Ah, I see, thanks. Are you planning to implement in-kernel migration or
>>>>> use a user-space tool?
>>>> That's the kind of answer I was hoping to get from Shuo. :-)
>>> OK, I try to do this. Wait for a couple of days.
>>>
>>> -LiuShuo
>> I found it's too complex to do the migration in Linux driver.
>>
>> Maybe we can add a uboot command (e.g. nand bbmigrate) to do it, once is
>> enough.
>
> Any reason not to do it automatically on the first U-Boot bad block
> scan, if the flash isn't marked as already migrated?
>
> Further discussion on the details of how to do it in U-Boot should move
> to the U-Boot list.

The limitation of the proposed bad block marker migration is that you
need to make sure the migration is done and only done once.  If it is
done more than once, the factory bad block marker is totally messed
up.  It requires a complex mechanism to automatically guarantee the
migration is only done once, and it still won't be 100% safe.

I would suggest we use a much easier compromise that we form the BBT
base on the factory bad block marker on first use of the flash, and
after that the factory bad block marker is dropped.  We just relies on
the BBT for information about bad blocks.  Although by doing so we
can't regenerate the BBT again,  as there is mirror for the BBT I
don't think we have too much risk.

- Leo
