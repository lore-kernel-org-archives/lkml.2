Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab1DTEkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 00:40:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51638 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1DTEkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 00:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=K6hinzBsP0NHOfcsrcnAGYHkmoCkrhtzV5lFnl1p0dh4PfBdTC1WaZ4RylGWL6bsqS
         5EKRgiXlLSx7KOWjhQQmObutfdbCvSvedgIcHQ+EKYxTT8UyIWkWvVeqL5dtDW0tjCEC
         BQp1HqlN9e4CTS85J6uvulzcoviOWUJDKWFAg=
MIME-Version: 1.0
In-Reply-To: <BANLkTimFd0ZuP2OQ4A_w7VFbDDN+rsvBtg@mail.gmail.com>
References: <BANLkTi=1svkDQt+HyaHgnann1Vre7CLUNQ@mail.gmail.com>
	<BANLkTimFd0ZuP2OQ4A_w7VFbDDN+rsvBtg@mail.gmail.com>
Date: Wed, 20 Apr 2011 13:40:06 +0900
Message-ID: <BANLkTi=9dROLwWH2J=Y_FmP+t=rkjMLBJg@mail.gmail.com>
Subject: Re: SPI read problem
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: =?UTF-8?B?5b6Q5bu66L6J?= <xujianhui168@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 12:19 PM, 徐建辉 <xujianhui168@gmail.com> wrote:
> you can use tasklet.
>
> 2011/4/19 Murali K. Vemuri <vemuri.muralikrishna@gmail.com>
>>
>> Hello there,
>> I have a device which is Written_to/Read_from using SPI Bus.
>>
>> I initialize the device like this:
>>
>> static int __init myDEV_init(void)
>> {
>>    return spi_register_driver(&myDEV_driver);
>> }
>> module_init(myDEV_init);
>>
>> My myDEV_probe() function looks like this:
>>
>> static int __devinit myDEV_probe(struct spi_device *spi)
>> {
>> .....
>> .....
>> /*when my CPU receives a particular IRQ, I have to do a spi_read() and
>> do couple of spi_write(), I am using like this:*/
>> err = request_threaded_irq (MY_DEV_IRQ, NULL, myDEV_irq_thread,
>>            IRQF_TRIGGER_RISING, "MYDEV", NULL);
>>
>> return 0;
>> }
>>
>> When the Interrupt is received by the CPU, myDEV_irq_thread is being
>> called.
>> However, in the ISR I have to do  spi_read(). This is always returning
>> "Timed out".
>>
>> To verify if the device is not at all working, along with registering
>> for the IRQ, I also created a char device through I did a IOCTL.
>> The IOCTL command in turn does spi_read(). In this case spi_read() is
>> successful.
>>
>> Since it is necessary to do spi_read() in my ISR, I searched around
>> and found some information that
>> spi_read() is callable only from contexts that can sleep.
>>
>> How can I make my ISR sleep? or is there any other way of doing this?
>>
>> Any help is highly appreciated.
>> Thanks & regards
>> Murali
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Hi there,

I tried using "tasklet", "workqueue" and semaphore ... all my attempts failed.
if there is any other method I should try, please let me know.
Thanks & regards
Murali
