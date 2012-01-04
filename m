Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2ADWoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:44:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:61831 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2ADWoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:44:08 -0500
Message-ID: <4F04D62B.50107@windriver.com>
Date: Wed, 4 Jan 2012 17:43:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <alan@linux.intel.com>, <gregkh@suse.de>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com> <20120104220158.3300d65b@pyramind.ukuu.org.uk>
In-Reply-To: <20120104220158.3300d65b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-01-04 05:01 PM, Alan Cox wrote:
> On Wed,  4 Jan 2012 15:01:27 -0500
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> The commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8,
>>
>>    "tty: move drivers/serial/ to drivers/tty/serial/"
>>
>> put most of the serial drivers together in one place, but the ones
>> that were hiding in drivers/char didn't get picked up in that change.
>>
>> They did get moved in commit a6afd9f3e819de4795fcd356e5bfad446e4323f2
>>
>>    "tty: move a number of tty drivers from drivers/char/ to drivers/tty/"
>>
>> but there was no distinction of serial vs. non-serial in the above.
>>
>> Here we take the remaining serial drivers (mostly legacy multiport
>> drivers) and put them alongside all the others in tty/serial/ dir.
>>
>> We can drop SERIAL_NONSTANDARD's dependency on HAS_IOMEM, since the
>> encompassing menu block already has that dependency called out.
> 
> NAK
> 
> The tty/serial directory is the stuff using serial_core. I'm not averse
> to moving the others down a layer into more appropriate places but its
> already too crowded and in need of re-ordering (eg tty/serial/8250/...
> might be an improvement)

OK, I can do 8250.  What do you have in mind for the legacy multiport
drivers then, leave them as-in in drivers/tty or another subdir just
for them?

Thanks,
P.

> 
