Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1DTNqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:46:00 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:59278 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1DTNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:45:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DAEE410.8020000@cam.ac.uk>
Date: Wed, 20 Apr 2011 14:48:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
CC: =?UTF-8?B?5b6Q5bu66L6J?= <xujianhui168@gmail.com>,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: SPI read problem
References: <BANLkTi=1svkDQt+HyaHgnann1Vre7CLUNQ@mail.gmail.com>	<BANLkTimFd0ZuP2OQ4A_w7VFbDDN+rsvBtg@mail.gmail.com> <BANLkTi=9dROLwWH2J=Y_FmP+t=rkjMLBJg@mail.gmail.com>
In-Reply-To: <BANLkTi=9dROLwWH2J=Y_FmP+t=rkjMLBJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/11 05:40, Murali K. Vemuri wrote:
> On Wed, Apr 20, 2011 at 12:19 PM, 徐建辉 <xujianhui168@gmail.com> wrote:
>> you can use tasklet.
>>
>> 2011/4/19 Murali K. Vemuri <vemuri.muralikrishna@gmail.com>
>>>
>>> Hello there,
>>> I have a device which is Written_to/Read_from using SPI Bus.
>>>
>>> I initialize the device like this:
>>>
>>> static int __init myDEV_init(void)
>>> {
>>>    return spi_register_driver(&myDEV_driver);
>>> }
>>> module_init(myDEV_init);
>>>
>>> My myDEV_probe() function looks like this:
>>>
>>> static int __devinit myDEV_probe(struct spi_device *spi)
>>> {
>>> .....
>>> .....
>>> /*when my CPU receives a particular IRQ, I have to do a spi_read() and
>>> do couple of spi_write(), I am using like this:*/
>>> err = request_threaded_irq (MY_DEV_IRQ, NULL, myDEV_irq_thread,
>>>            IRQF_TRIGGER_RISING, "MYDEV", NULL);
This should be fine.  The thread can sleep just fine. We do this
all over the place.  Could be something to do with the irq
handling on the device.
>>>
>>> return 0;
>>> }
>>>
>>> When the Interrupt is received by the CPU, myDEV_irq_thread is being
>>> called.
>>> However, in the ISR I have to do  spi_read(). This is always returning
>>> "Timed out".
That's very suspicious.  What spi controller are we dealing with here?
>>>
>>> To verify if the device is not at all working, along with registering
>>> for the IRQ, I also created a char device through I did a IOCTL.
>>> The IOCTL command in turn does spi_read(). In this case spi_read() is
>>> successful.
>>>
>>> Since it is necessary to do spi_read() in my ISR, I searched around
>>> and found some information that
>>> spi_read() is callable only from contexts that can sleep.
>>>
>>> How can I make my ISR sleep? or is there any other way of doing this?
>>>
>>> Any help is highly appreciated.
>>> Thanks & regards
>>> Murali
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
> 
> Hi there,
> 
> I tried using "tasklet", "workqueue" and semaphore ... all my attempts failed.
> if there is any other method I should try, please let me know.
Something nastier is happening here.  It's not a problem with what you've
presented in this email.  Perhaps a minimum example of the full code surrounding
the problem may help us diagnose it.  
