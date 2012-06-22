Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2FVDLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:11:18 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64487 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab2FVDLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC1C3@DQHE02.ent.ti.com>
References: <1340323926-6826-1-git-send-email-gshark.jeong@gmail.com>
 <1340323926-6826-2-git-send-email-gshark.jeong@gmail.com> <A874F61F95741C4A9BA573A70FE3998FC1C3@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 22 Jun 2012 11:10:55 +0800
X-Google-Sender-Auth: iEiZ3Bu8DbbUgqoYTM0rYsU069Y
Message-ID: <CAK5ve-K=Cr4jg0aN128DN4nQLBHzJ4kocBs3D53PU0PWsUy_1A@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] leds: Add LED driver for lm3556 chip
To: "G.Shark Jeong" <gshark.jeong@gmail.com>, "Kim, Milo" <Milo.Kim@ti.com>,
        Axel Lin <axel.lin@gmail.com>
Cc: "Jeong, Daniel" <Daniel.Jeong@ti.com>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 9:05 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
>> LM3556 :
>> The LM3556 is a 4 MHz fixed-frequency synchronous boost
>> converter plus 1.5A constant current driver for a high-current white
>> LED.
>
> Overall, it looks pretty good to me, especially core functionality of lm3556 is well supported and it's easy to use.
>
> Just one thing to be better,
> I would suggest to use module_i2c_driver() rather than lm3556_init/lm3556_exit for code simplicity.
>

Hi G.Shark,

I also think this patch is good enough for merging now after your
fixed several issues pointed out by Axel Lin.
I fixed this module_i2c_driver() issue mentioned by Milo here and push
it to my -devel branch.
If there is no problem, I will applied it to for-next branch.

Thanks,
-Bryan

>> +static int __init lm3556_init(void)
>> +{
>> +     return i2c_add_driver(&lm3556_i2c_driver);
>> +}
>> +
>> +static void __exit lm3556_exit(void)
>> +{
>> +     i2c_del_driver(&lm3556_i2c_driver);
>> +}
>> +
>> +module_init(lm3556_init);
>> +module_exit(lm3556_exit);
>
> module_i2c_driver(lm3556_i2c_driver);
>
> Thanks,
> Milo -



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
