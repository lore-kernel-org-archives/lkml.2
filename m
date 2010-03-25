Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0CYTBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab0CYTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:01:10 -0400
Message-ID: <4BABB2DB.8030305@redhat.com>
Date: Thu, 25 Mar 2010 16:00:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jon Smirl <jonsmirl@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091215115011.GB1385@ucw.cz> <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz> <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com> <20091215201933.GK24406@elf.ucw.cz> <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com> <20091215203300.GL24406@elf.ucw.cz> <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com> <20100325183259.GA22902@elf.ucw.cz>
In-Reply-To: <20100325183259.GA22902@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> This were the original plan we've discussed, back in December:
> ....
> 
> Seems sane.
> 
>> struct keycode_table_entry {
>> 	unsigned keycode;
>> 	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
>> 	int len;
>> }
> 
> What about
> 
> struct keycode_table_entry {
> 	unsigned keycode;
> 	int len;
> 	char scancode[];
> }
> 
> ? gcc extension, but commonly used around kernel.

Seems fine. Maybe we could just use "char *scancode" to avoid using a
gcc extension on a public interface.


-- 

Cheers,
Mauro
