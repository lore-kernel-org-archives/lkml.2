Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab2DFBMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:12:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51545 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758Ab2DFBMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:12:49 -0400
Message-ID: <1333674768.23520.123.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Date: Thu, 05 Apr 2012 18:12:48 -0700
In-Reply-To: <1333655231.725.27.camel@mop>
References: <1333569554.864.3.camel@mop>
	 <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
	 <1333655231.725.27.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 21:47 +0200, Kay Sievers wrote:

> Better?
> 
>   [root@mop ~]# cat /dev/kmsg
[]
>   6,5,0; BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>   6,6,0; BIOS-e820: 0000000000100000 - 000000001fffd000 (usable)
>   6 ,7,0; BIOS-e820: 000000001fffd000 - 0000000020000000 (reserved)

Not really, why the space between the 6 and the comma?

> This patch extends printk() to be able to attach arbitrary key/value
> pairs to logged messages,

Bad commit changelog.

It does not extend printk().  printk() is a function call.

It extends the message logging subsystem to include the
printk_emit() and vprintk_emit() functions, which can
add decidedly not arbitrary key/value pairs, but some
additional subsystem specific information.

> - Output of dev_printk() is reliably machine-readable now.

No, it's not.

An output header simply contains additional
structured information.  The message portion
can still be arbitrary gobbledygook.

I still think this should be 3 patches not 1.


