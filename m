Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1HJAQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:16:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51159 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1HJAQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:16:47 -0400
MIME-Version: 1.0
Date: Wed, 10 Aug 2011 09:16:46 +0900
Message-ID: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
Subject: kernel panic with simple driver
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I have a small driver code with which I am randomly receiving kernel
panic. Can someone help me what is the mistake here?
The kernel panic is exactly caught to be at "add_timer (&my_timer) ".
I am able to get the print "Kicking off the timer" when the panic
happens.

Also, I could not observe any specific pattern in which the panic
occurs. But it is purely random. So far I was able to reproduce the
panic thrice out of 100+ attempts.

In all other attempts, my_dev_ioctl is called correctly and works correctly.

struct timer_list my_timer;

static int my_dev_ioctl(struct inode *inode, struct file *file,
                unsigned int cmd, unsigned long arg)
{
    switch(cmd)
    {
        case MATCH_CASE:
            if (timer_pending (&my_timer))
            {
                printk(KERN_ERR "Timer currently pending, not adding
any more\n");
            }
            else
            {
                printk(KERN_ERR "Kicking off the timer\n");
                add_timer(&my_timer);
            }
            break;
        default:
            break;
    }
    return 0;
}

static struct miscdevice my_dummy_dev =
{
    .minor = MISC_DYNAMIC_MINOR,
    .name = "dummy_dev",
    .fops = &my_dev_fops,
};

static int __init my_dev_init(void)
{
    /*initialize some GPIOs */
    init_timer (&my_timer);
    my_timer.data = 0;
    my_timer.expires = jiffies + msecs_to_jiffies(500);
    my_timer.function = ring_led_detect_timer;
    misc_register(&mbi5025_dev);
}
module_init(my_dev_init);


Thanks in advance
Murali
