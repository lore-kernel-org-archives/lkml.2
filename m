Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2IYPkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:40:11 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:52338 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab2IYPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:40:10 -0400
Message-ID: <5061D057.9000308@parrot.com>
Date: Tue, 25 Sep 2012 17:40:07 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <alan@lxorguk.ukuu.org.uk>,
        Matthieu Castet <matthieu.castet@parrot.com>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr> <5040EAF7.9010003@codeaurora.org>
In-Reply-To: <5040EAF7.9010003@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd a écrit :
> On 8/31/2012 4:47 AM, Matthieu CASTET wrote:
>> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
> 
> Please consider adding some sort of commit text. Does this add some new
> feature I may want on some downstream distro kernel?
> 
ok
> 
> It's unfortunate that the main logic is duplicated. I wonder if we could
> push the runtime decision slightly lower into the accessor functions
> instead and make some new functions dcc_tx_busy() and dcc_rx_busy() or
> something. Then these loops stay the same.
see my previous mail

>> +static inline char __dcc_getchar(void)
>> +{
>> +	char c;
>> +
>> +	asm __volatile__ ("mrc p14, 0, %0, c1, c0	@ read comms data reg"
>> +		: "=r" (c));
>> +
> 
> Do you see any multiple character inputs? I think you may need an isb
> here similar to the v6/7 code and in the putchar as well.
I don't see multiple character.
On armv5 isb is only a memory barrier (__asm__ __volatile__ ("" : : : "memory"))
 and it may be not need for dcc operation.


Matthieu
