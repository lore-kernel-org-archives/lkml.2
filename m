Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0INM6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:58:03 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:53437 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0INM57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:57:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C8F7157.9060005@jic23.retrosnub.co.uk>
Date: Tue, 14 Sep 2010 13:57:59 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
CC: Jonathan Cameron <arm@jic23.retrosnub.co.uk>,
        Joe Perches <joe@perches.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
References: <cover.1284406638.git.joe@perches.com>	<b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>	<4C8E84A0.1010606@jic23.retrosnub.co.uk> <19599.9719.562406.692216@ipc1.ka-ro>
In-Reply-To: <19599.9719.562406.692216@ipc1.ka-ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/10 08:36, Lothar Waßmann wrote:
> Hi,
> 
> Jonathan Cameron writes:
>>  Commit message is  somewhat inaccurate...
>>
>> On 09/13/10 20:47, Joe Perches wrote:
>>> Signed-off-by: Joe Perches <joe@perches.com>
>>> ---
>>>  drivers/i2c/busses/i2c-stu300.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
>>> index 495be45..2f7c09c 100644
>>> --- a/drivers/i2c/busses/i2c-stu300.c
>>> +++ b/drivers/i2c/busses/i2c-stu300.c
>>> @@ -871,7 +871,7 @@ stu300_probe(struct platform_device *pdev)
>>>  	struct resource *res;
>>>  	int bus_nr;
>>>  	int ret = 0;
>>> -	char clk_name[] = "I2C0";
>>> +	char clk_name[sizeof("I2Cx")];
>>>  
>>>  	dev = kzalloc(sizeof(struct stu300_dev), GFP_KERNEL);
>>>  	if (!dev) {
>>> @@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
>>>  	}
>>>  
>>>  	bus_nr = pdev->id;
>>> -	clk_name[3] += (char)bus_nr;
>>> +	sprintf(clk_name, "I2C%c", '0' + bus_nr);
>> I'm guessing that there are never more than a couple of these.
>> Why is this method a better bet than just putting %d?
>>
> '%c' will only ever produce one byte of output while '%d' may
> produce up to 11 bytes depending on the value of bus_nr thus
> overflowing the buffer.
Then use an snprintf, or apply a check to ensure it isn't bigger than
9.

If you don't mind having clocks named i2c$ or something equally
silly then I guess this is fine.  To my mind, if that is possible
this is a bug that should be fixed rather than avoided.


