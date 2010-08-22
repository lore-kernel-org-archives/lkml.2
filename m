Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0HVXAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 19:00:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56622 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0HVXAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 19:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VtYPcRDLZW9NzgvaQ8gyVZcm2Sab1qJ4IJKNxbDagAxUbqQYJs22sAo+JHmdNtaV0a
         LvnA+lsf9UoGy5hT9zk2sMmInyS45OvFWgCpg1wWm+b+EdwRvDCLrCBY6UqEo44eUh+J
         Z1N83r32/0DCsw/JoyLUC+kKUItKTVd10kB9E=
Subject: ldd module param practice
From: runcoderen <runcoderzhcn@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 07:00:18 +0800
Message-ID: <1282518018.1661.15.camel@bencharluo-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:

#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>

MODULE_LICENSE("Dual BSD/GPL");

static char *whom = "world";
static char howmany = 1;

module_param(howmany, int, S_IRUGO);
module_param(whom, charp, S_IRUGO);

static int hello_init(void)
{
printk(KERN_ALERT "Hello, world\n");
return 0;
}

static void hello_exit(void)
{
printk(KERN_ALERT "Goodbye, cruel world\n");
}

module_init(hello_init);
module_exit(hello_exit);

insmod hellop.ko howmany=10 whom="Mom"

this code I want to printk "hello Mom" 10 times.

but it doesn't work. so I modified static int howmany = 10, it doesn't
work either.
I don't know whether it's my wronging use?

-- 

/****************************************
http://runcoderen.wordpress.com/
****************************************/

