Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1DGS6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:58:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56413 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab1DGS6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ShERcGvQpu3U2wp1LWD+zB9voteAdDCUYZ1xoCqpkQP5V3tMzvaT/chhH9IxtiieON
         2LiTgYXvv0euN0Ny8cGAtlf5cTn7wpjblM6i64WmhN3YsGQrF7B5fE64ACYX1gxrl8S+
         40ssTNsRtIB/8xu5IzaXFx2tfI8Nb3jx0UG08=
MIME-Version: 1.0
In-Reply-To: <4D9E04F0.5010004@ronetix.at>
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org> <4D9E04F0.5010004@ronetix.at>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Apr 2011 14:57:51 -0400
X-Google-Sender-Auth: bkWdNeYTF8_gfB7svf4QoRjWUHA
Message-ID: <BANLkTinTWwLB0gi0qKQfCYQ8x6PTuL9-uA@mail.gmail.com>
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
To: RONETIX - Asen Dimov <dimov@ronetix.at>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        linux-arm-msm@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 14:39, RONETIX - Asen Dimov wrote:
> On 11/30/2010 09:25 PM, Daniel Walker wrote:
>> This driver adds a basic console that uses the arm JTAG
>> DCC to transfer data back and forth. It has support for
>> ARMv6 and ARMv7.
>>
>> This console is created under the HVC driver, and should be named
>> /dev/hvcX (or /dev/hvc0 for example).
>>
>>  drivers/char/Kconfig   |    9 +++
>>  drivers/char/Makefile  |    1 +
>>  drivers/char/hvc_dcc.c |  133
>> ++++++++++++++++++++++++++++++++++++++++++++++++
>
> ...
>
> this DCC driver implements "one channel", but what about implementing
> "multiple channels". For example reserve few(3) bits for channel number,
> and two bits for carried data, then fill the rest bytes with with some data
> and send the word(32 bits) over DCC. On the Linux side writing on /dev/hvcX
> puts the number X as channel number, and on the other side the CPU
> emulator gets the data and redistribute it to TCP/IP socket.
>
> I have started write some code implementing this. Are there any one
> interested
> in this multiple channels, and are there any one started to work on it?

this sort of multiplexing of the data stream sounds like the job for
userspace ?  or maybe a line discipline ?  inserting structured data
into the kernel driver doesnt sound right to me ...
-mike
