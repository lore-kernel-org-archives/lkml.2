Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1FIOlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:41:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44406 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1FIOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:41:36 -0400
Message-ID: <4DF0DB7C.1040009@zytor.com>
Date: Thu, 09 Jun 2011 07:41:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 5/5] i8253: Cleanup outb/inb magic
References: <20110609130509.346588418@linutronix.de> <20110609130622.348437125@linutronix.de> <20110609133448.GA8772@linux-mips.org>
In-Reply-To: <20110609133448.GA8772@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 06:34 AM, Ralf Baechle wrote:
> On Thu, Jun 09, 2011 at 01:08:30PM -0000, Thomas Gleixner wrote:
> 
>> Remove the hysterical outb/inb_pit defines and use outb_p/inb_p in the
>> code.
> 
> FWIW, I've traced the use of inb_p and outb_p to access the PIT timer
> all the way back to Linux 0.10
> 
> I wonder if any of the systems affected actually has enough memory to boot
> a modern kernel or if the _p versions have become useless bagagge that
> should be dropped - cleanup which would then also allow more code to the
> iomap() API.
> 
> I'm interested because quite a few MIPS systems have been built based on
> Intel, OPTi and other chipsets which may or may not have been affected.
> 

On the x86 side, we already have configurability of the delay in
inb_p/outb_p... one option could be null delay.

	-hpa

