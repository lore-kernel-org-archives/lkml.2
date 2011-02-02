Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1BBEhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:37:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42158 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1BBEhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:37:20 -0500
MIME-Version: 1.0
In-Reply-To: <20110202043121.GF29148@angua.secretlab.ca>
References: <20110117220415.GB17963@angua.secretlab.ca> <1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
 <20110202043121.GF29148@angua.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 1 Feb 2011 21:36:59 -0700
X-Google-Sender-Auth: Q_b7ryk0LTWjdBoruxPJdvc-KyQ
Message-ID: <AANLkTikxSrwOfU=m_h+6G5hQMk6drOpqOPSfbBdzg53g@mail.gmail.com>
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 9:31 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jan 24, 2011 at 01:58:13PM +0800, Thomas Chou wrote:
>> From: Walter Goossens <waltergoossens@home.nl>
>>
>> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>> v2 use const and add compat version.
>>
>>  drivers/input/serio/altera_ps2.c |   11 +++++++++--
>>  1 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
>> index 7998560..63325ee 100644
>> --- a/drivers/input/serio/altera_ps2.c
>> +++ b/drivers/input/serio/altera_ps2.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>> +#include <linux/of.h>
>>
>>  #define DRV_NAME "altera_ps2"
>>
>> @@ -173,6 +174,12 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>>       return 0;
>>  }
>>
>> +static const struct of_device_id altera_ps2_match[] = {
>> +     { .compatible = "altr,ps2-1.0", },
>
> I thought I had seen 'altera' instead of an abbreviation being used in
> a previous patch.  I don't care much whether 'altr' or 'altera' is
> used, but I'd like to know that there is consensus from the Altera
> users so that all the drivers use the same prefix.

Oh, and this patch should add documentation to
Documentation/devicetree/bindings/spi specifying exactly what device
this compatible string represents and what properties are expected to
be in the node (if any) beyond the standard reg, interrupts, etc.  It
doesn't need to be huge and detailed, but it at least needs to show
that the string is in use.  This comment goes for the other patches
that add bindings too.

g.
