Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1G3Sda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:33:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1G3Sd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:33:26 -0400
Message-ID: <4E344E72.1040202@lwfinger.net>
Date: Sat, 30 Jul 2011 13:33:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ide-cs
References: <4E33851C.2000806@lwfinger.net> <20110730052826.GB12383@isilmar-3.linta.de>
In-Reply-To: <20110730052826.GB12383@isilmar-3.linta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 12:28 AM, Dominik Brodowski wrote:
> Larry,
>
> On Fri, Jul 29, 2011 at 11:14:20PM -0500, Larry Finger wrote:
>> With kernel 3.0, my external hard drive attached to a PCMCIA card reports
>> "irq 11: nobody cared (try booting with the "irqpoll" option)". The
>> driver in question is ide-cs. When I try irqpoll, the device works
>> correctly. Naturally, the interrupt is shared with yenta, the PCMCIA
>> adapter driver. In addition, that same interrupt is used by a BCM4318
>> Cardbus device.
>>
>> I plan on preparing a Bugzilla entry for this problem, but I'm not quite
>> ready. What I would like to know if there is any documentation on what
>> kinds of changes are needed to fix the problem.
>
> Let me guess: it worked fine in 2.6.39, or .38? Output of "lspci -vv",
> "dmesg" for a working and a non-working kernel would be good starting points
> for trying to debug this issue.

It worked fine in 2.6.37 and is a regression. The bug is #40362.

I tried to bisect between 2.6.38 and 2.6.37, but didn't really get anywhere. As 
noted in the bug report, 38 and 39 lock the computer when I plug in. Only 3.0 
comes back with the nobody cared message.

Larry
