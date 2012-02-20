Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2BTLXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:23:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59918 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2BTLXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:23:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djkurtz@google.com designates 10.50.95.195 as permitted sender) smtp.mail=djkurtz@google.com; dkim=pass header.i=djkurtz@google.com
MIME-Version: 1.0
In-Reply-To: <20120106123531.3b5ca7db@endymion.delvare>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org> <20120106123531.3b5ca7db@endymion.delvare>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 20 Feb 2012 19:23:10 +0800
X-Google-Sender-Auth: kLvIJb75R3s_lmvdXvnGLIOwqhM
Message-ID: <CAGS+omBvULkWsowprvVWkodBxT=diui7g5GtKZ0mb=Uy7DZKtg@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] i2c: i801: enable irq
To: Jean Delvare <khali@linux-fr.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 7:35 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Daniel,
>
> On Fri,  6 Jan 2012 18:58:19 +0800, Daniel Kurtz wrote:
>> This is a second version of a set of patches enables the Intel PCH SMBus
>> controller interrupt.  It refactors the second two patches a little bit by
>> relying on DEV_ERR interrupt for timeouts, instead of using an explicit
>> wait_event_timeout.
>>
>> The first attempt received absolutely no response. Maybe this time someone
>> will be interested.
>
> I was on vacation. But I am very interested and will review and test
> your patches. There have been several attempts to add IRQ support to
> i2c-i801 in the past but each time there was a blocker issue which
> prevented it from making it into mainline. Hopefully this time we'll
> get it there!
>
>>
>> The SMBus Host Controller Interrupt can signify:
>>  INTR - the end of a complete transaction
>>  DEV_ERR - that a device did not ACK a transaction
>>  BYTE_DONE - the completion of a single byte during a byte-by-byte transaction
>>
>> This patchset arrives with the following caveats:
>>
>>  1)  It has only been tested with a Cougar Point (Intel 6 Series PCH) SMBus
>> controller, so the irq is only enabled for that chip type.
>
> I can test on ICH10 easily, and also on ICH7 and ICH3-M if needed.
>
>>  2) It has not been tested with any devices that do transactions that use the
>>     PEC.  In fact, I believe that an additional small patch would be required
>>     to the driver working correctly in interrupt mode with PEC.
>>
>>  3) It has not been tested in SMBus Slave mode.
>>
>>  4) It has not been tested with SMI#-type interrupts.
>>
>>  5) The BIOS has to configure the PCH SMBus IRQ properly.
>>
>>  6) It has not been tested with a device that does byte-by-byte smbus (non-i2c)
>>     reads.
>
> I think I can test this.
>
>>  7) It has not been tested with smbus 'process call' transactions.
>
> But not this.
>
>> If would be very helpful if somebody could help test on other chipsets, with
>> a PEC device, or on additional BIOS that woudl be very helpful.
>
> I will do what I can with the hardware I have here.

Jean,
Ping?


>
>> In the meantime, the interrupt behavior is only enabled on the Cougar Point,
>> and even here, it can be completely disabled with the "Interrupt" feature like
>> other advanced features of the driver.
>>
>> Daniel Kurtz (3):
>>   i2c: i801: refactor i801_block_transaction_byte_by_byte
>>   i2c: i801: enable irq for i801 smbus transactions
>>   i2c: i801: enable irq for byte_by_byte transactions
>>
>>  drivers/i2c/busses/i2c-i801.c |  199 ++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 175 insertions(+), 24 deletions(-)
>
> --
> Jean Delvare
