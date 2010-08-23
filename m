Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0HWCRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:17:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39508 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0HWCRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ig/nJroOjetR+njGxGz0wMsJsqSvog9xawdeqMUBNMxK9RoBmDfzBldBZL4+pbt0Zj
         p4DisNca2JW9G9gZCARYrcPgROeT3euX3qY3V2oNgsazpCQVoC8lgd86DWzm1HbOPMgd
         rXyaLN3DPSQJWTAWso7JiXlQaFmvapssmeejM=
Date: Mon, 23 Aug 2010 10:19:02 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: ldd module param practice
Message-ID: <20100823021902.GA5168@cr0.nay.redhat.com>
References: <1282518018.1661.15.camel@bencharluo-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282518018.1661.15.camel@bencharluo-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:00:18AM +0800, runcoderen wrote:
>hi all:
>
>#include <linux/init.h>
>#include <linux/module.h>
>#include <linux/moduleparam.h>
>
>MODULE_LICENSE("Dual BSD/GPL");
>
>static char *whom = "world";
>static char howmany = 1;
>
>module_param(howmany, int, S_IRUGO);
>module_param(whom, charp, S_IRUGO);
>
>static int hello_init(void)
>{
>printk(KERN_ALERT "Hello, world\n");
>return 0;
>}
>
>static void hello_exit(void)
>{
>printk(KERN_ALERT "Goodbye, cruel world\n");
>}
>
>module_init(hello_init);
>module_exit(hello_exit);
>
>insmod hellop.ko howmany=10 whom="Mom"
>
>this code I want to printk "hello Mom" 10 times.


How can it work? You neither have a loop nor use 'whom'
in your hello_init()...

You need:

statick int hello_init(void)
{
   int i;
   for (i=0; i<howmany; i++)
      printk(KERN_WARNING "Hello, %s\n", whom);
   return 0;
}
