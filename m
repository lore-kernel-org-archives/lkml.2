Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1AQVai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:30:38 -0500
Received: from smtpq4.gn.mail.iss.as9143.net ([212.54.34.167]:53864 "EHLO
	smtpq4.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078Ab1AQVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:30:36 -0500
X-Greylist: delayed 1587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 16:30:36 EST
Message-ID: <4D34AEC3.60801@home.nl>
Date: Mon, 17 Jan 2011 22:04:03 +0100
From: Walter Goossens <waltergoossens@home.nl>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Chou <thomas@wytron.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] alter_ps2: Add devicetree support
References: <4D040D1C.2020705@home.nl> <1295245760-4566-1-git-send-email-thomas@wytron.com.tw> <AANLkTi=8+Q5dm+5Pa-cYkmaBWQ4S7jgjZOL0ovtmrdxB@mail.gmail.com>
In-Reply-To: <AANLkTi=8+Q5dm+5Pa-cYkmaBWQ4S7jgjZOL0ovtmrdxB@mail.gmail.com>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1PewFC-0003VU-1s
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=1.218, vereist 5, ALL_TRUSTED -1.00, BAYES_05 -0.50,
	HELO_LH_HOME 1.74, RDNS_DYNAMIC 0.98)
X-ZiggoSMTP-MailScanner-SpamScore: s
X-ZiggoSMTP-MailScanner-From: waltergoossens@home.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/11 7:59 AM, Grant Likely wrote:
> On Sun, Jan 16, 2011 at 11:29 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
>> From: Walter Goossens <waltergoossens@home.nl>
>>
>> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>>  drivers/input/serio/altera_ps2.c |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
>> index 7998560..93054a1 100644
>> --- a/drivers/input/serio/altera_ps2.c
>> +++ b/drivers/input/serio/altera_ps2.c
>> @@ -19,6 +19,9 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/io.h>
>>  #include <linux/slab.h>
>> +#ifdef CONFIG_OF
>> +#include <linux/of.h>
>> +#endif
>>
>>  #define DRV_NAME "altera_ps2"
>>
>> @@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>>        return 0;
>>  }
>>
>> +#ifdef CONFIG_OF
>> +static struct of_device_id altera_ps2_match[] = {
>> +       {
>> +               .compatible = "altera,altera_ps2",
>> +       },
> So is this an FPGA soft core PS2 device?  Is there any kind of version
> attached to the soft core?  The compatible value should specify an
> exact version of the implementation that this driver works with.
> (Newer core versions can claim compatibility with older ones, so the
> driver's compatible list doesn't need to be exhaustive).
>
What's the preferred way of versioning components in a device-tree?
Quite a few components inside an fpga will get a new version number with
every release of the tools. For example components supplied by Altera
will get a new number with every release of their IP library (approx.
twice a year) even when (at least from a software point of view) there
is nothing changed in the core. Should we add the number to the
"compatible" name and possibly get slightly more bulky drivers, or add a
version tag to the components where a driver can make decisions based on
the version of the core (if needed)?
Another way to reduce the number of lines in a compatible section would
be to add both their versioned and unversioned compatible entry in the
dts so drivers not needing a specific version don't need to supply the
entire list.
We do have the version numbers available when generating the DTS and
NiosII is still quite new to device-tree so we are still flexible in
fixing this in the best possible way.

> Otherwise, this patch looks correct.
>
> g.
>
>> +       {},
>> +}
>> +MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
>> +#endif /* CONFIG_OF */
>> +
>>  /*
>>  * Our device driver structure
>>  */
>> @@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
>>        .driver = {
>>                .name   = DRV_NAME,
>>                .owner  = THIS_MODULE,
>> +#ifdef CONFIG_OF
>> +               .of_match_table = altera_ps2_match,
>> +#endif
>>        },
>>  };
>>
>> --
>> 1.7.3.4
>>
>>
>
>

