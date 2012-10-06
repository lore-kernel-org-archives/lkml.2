Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2JFNGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:06:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53989 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2JFNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <1349525982.2008.86.camel@joe-AO722>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-3-git-send-email-cheiny@synaptics.com>
	<1349525982.2008.86.camel@joe-AO722>
Date: Sat, 6 Oct 2012 09:06:16 -0400
Message-ID: <CAHdPZaOTwAvuhLj6wmUaFnx9CxjwZNM0QEFzu2p+jaC7jAdAig@mail.gmail.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Christopher Heiny <cheiny@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 8:19 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2012-10-05 at 21:09 -0700, Christopher Heiny wrote:
> []
>
> Just some trivial comments:
>
>> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
> []
>> @@ -0,0 +1,1529 @@
> []
>> +static ssize_t delay_write(struct file *filp, const char __user *buffer,
>> +                        size_t size, loff_t *offset) {
>> +     struct driver_debugfs_data *data = filp->private_data;
>> +     struct rmi_device_platform_data *pdata =
>> +                     data->rmi_dev->phys->dev->platform_data;
>> +     int retval;
>> +     char local_buf[size];
>> +     unsigned int new_read_delay;
>> +     unsigned int new_write_delay;
>> +     unsigned int new_block_delay;
>> +     unsigned int new_pre_delay;
>> +     unsigned int new_post_delay;
>> +
>> +     retval = copy_from_user(local_buf, buffer, size);
>> +     if (retval)
>> +             return -EFAULT;
>> +
>> +     retval = sscanf(local_buf, "%u %u %u %u %u", &new_read_delay,
>> +                     &new_write_delay, &new_block_delay,
>> +                     &new_pre_delay, &new_post_delay);
>> +     if (retval != 5) {
>> +             dev_err(&data->rmi_dev->dev,
>> +                     "Incorrect number of values provided for delay.");
>> +             return -EINVAL;
>> +     }
>> +     if (new_read_delay < 0) {
>
> These are unnecessary tests as unsigned values are never < 0.
>

Nope.

1 main()
  2 {
  3         char buf[100] = "1 -2";
  4         int t, t2;
  5
  6         sscanf(buf, "%u %u", &t, &t2);
  7
  8         if (t > 0) {
  9                 printf("greater\n");
 10         }
 11
 12         if (t2 > 0) {
 13                 printf("greater\n");
 14         } else {
 15                 printf("lesser\n");
 16         }
 17 }


Thanks,
