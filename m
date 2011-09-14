Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1INHPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:15:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55370 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1INHPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110913082448.GA5046@polaris.bitmath.org>
References: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
 <1315029042-27513-2-git-send-email-martinez.javier@gmail.com> <20110913082448.GA5046@polaris.bitmath.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 14 Sep 2011 09:14:50 +0200
Message-ID: <CAAwP0s0FvkzTUo5kAZE_pd_8u-znDvoLks74gf8+75cUF0aM2g@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:24 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Javier,
>
>> Cypress TrueTouch(tm) Standard Product controllers are found in
>> a wide range of embedded devices. This driver add support for a
>> variety of TTSP controllers.
>>
>> The driver is composed of a core driver that process the data sent by
>> the contacts and a set of bus specific interface modules. This patch
>> adds the base core TTSP driver.
>>
>> The original author of the driver is Kevin McNeely <kev@cypress.com>
>>
>> Since the hardware is capable of tracking identifiable contacts and the
>> original driver used multi-touch protocol type A (stateless), multi-touch
>> protocol type B (stateful) support was added by Javier Martinez Canillas.
>>
>> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
>> ---
>> Changes since v1: Fix issues called out by Dmitry Torokhov
>>      - Add msleep() delays between retries for read and write operations
>>      - Change cyttsp_core_init() to receive the IRQ from the client data
>>        instead of obtaining from the platform_data
>
> Compared to the staging version you sent earlier, this version seems
> to be a step back towards the original version regarding the MT
> implementation. Is this the right patch?
>
> Thanks,
> Henrik
>

Hello Henrik,

Yes it is the right patch, or at least the patch I meant to send. The
staging version I send earlier didn't support multi-touch protocol
type A.

Since Cypress HW can do finger (contact) tracking, a requirement was
to add multi-touch protocol type B support to the driver. This
patch-set does that and also fixes some issues that Dmitry had with
this patch-set in its V1.

Even when Cypress touchscreen can keep track of each contact, it
doesn't preserve the contact index. So if I have 3 fingers that were
pressed in order and the touchscreen assigned it the values:

10 11 12

And then I lift the first finger (10), the hardware reports:

11 12

Maybe that is why the driver seems complex, you have to keep a copy of
the hardware state and iterate over all previous contacts to see if
there are new fingers and if the old ones have been lifted.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
