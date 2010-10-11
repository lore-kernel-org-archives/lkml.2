Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0JKTsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:48:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0JKTsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:48:14 -0400
Message-ID: <4CB369E5.6040600@kernel.org>
Date: Mon, 11 Oct 2010 12:47:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, setup: Check early serial console per string instead
 of one char
References: <4CB34E82.8030802@kernel.org> <4CB3552C.5050808@zytor.com>
In-Reply-To: <4CB3552C.5050808@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 11:19 AM, H. Peter Anvin wrote:
> On 10/11/2010 10:50 AM, Yinghai Lu wrote:
>>
>> Move out serial_putchar() calling out of putchar
>> Let puts() to call serial_putchar() directly.
>>
>> So only need to check early_serial_base per string.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> This seems to add a bunch of code for zero benefit.  Testing a global
> variable is zero cost compared to either a BIOS call or poking a serial
> port.

some server have bios serial console redirection support, and bios int call could send char to screen and serial port.

in that case, take out serial_putchar from putchar could produce more readable print out from serial console

Thanks

Yinghai
