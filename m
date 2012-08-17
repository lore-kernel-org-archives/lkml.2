Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2HQPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:12:33 -0400
Received: from mail1.windriver.com ([147.11.146.13]:41780 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab2HQPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:12:24 -0400
Message-ID: <502E5F47.6040703@windriver.com>
Date: Fri, 17 Aug 2012 11:12:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Worsley <amworsley@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Roland Ramthun <mail@roland-ramthun.de>
Subject: Re: [v2.6.34-stable 137/165] USB: Fix Corruption issue in USB ftdi
 driver ftdi_sio.c
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-138-git-send-email-paul.gortmaker@windriver.com> <20120817143642.GA4039@herton-Z68MA-D2H-B3>
In-Reply-To: <20120817143642.GA4039@herton-Z68MA-D2H-B3>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-17 10:36 AM, Herton Ronaldo Krzesinski wrote:
>> commit b1ffb4c851f185e9051ba837c16d9b84ef688d26 upstream.
>> > 
>> > Fix for ftdi_set_termios() glitching output
>> > 
>> > ftdi_set_termios() is constantly setting the baud rate, data bits and parity
>> > unnecessarily on every call, . When called while characters are being
>> > transmitted can cause the FTDI chip to corrupt the serial port bit stream
>> > output by stalling the output half a bit during the output of a character.
>> > Simple fix by skipping this setting if the baud rate/data bits/parity are
>> > unchanged.
>> > 
>> > Signed-off-by: Andrew Worsley <amworsley@gmail.com>
> [...]
> 
> commit 108e02b12921078a59dcacd048079ece48a4a983 ("USB: ftdi_sio: fix
> initial baud rate") says it addresses a regression on this change,
> something to consider for inclusion with this update.

Thanks Herton, I've queued this and pushed it to 34-longterm-queue.

Paul.
--
