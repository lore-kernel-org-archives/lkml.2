Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936287Ab0CONl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:41:58 -0400
Received: from av11-1-sn2.hy.skanova.net ([81.228.8.183]:60692 "EHLO
	av11-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936274Ab0CONl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:41:56 -0400
Message-ID: <4B9E391A.5050808@pelagicore.com>
Date: Mon, 15 Mar 2010 14:41:46 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-serial@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
References: <4B532CF5.7080000@gmail.com> <20100117181702.026269e9@lxorguk.ukuu.org.uk> <4B535ED8.2050703@gmail.com> <4B9E0160.5000900@pelagicore.com> <4B9E3747.9060400@gmail.com>
In-Reply-To: <4B9E3747.9060400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 02:33 PM, Roel Kluin wrote:
> Hi Richard,
>
>>>        if (mctrl&   TIOCM_RTS)
>>>            iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
>>>        else
>>> -        iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
>>> +        iowrite8(TIMBUART_CTRL_CTS, port->membase + TIMBUART_CTRL);
>>
>> This is not completely correct. CTS is a read only bit and we are to
>> stop signal RTS. So the line should look like:
>> iowrite8(0, port->membase + TIMBUART_CTRL);
>
> It appears as if this will also unset TIMBUART_CTRL_CTS (which is
> probably ok since it's read-only) but TIMBUART_CTRL_FLSHTX and
> TIMBUART_CTRL_FLSHRX as well.

TIMBUART_CTRL_FLSH(RX/TX) are write only bits, writing a 1 to these will
flush the corresponding FIFO. In this case we should not flush the FIFO:s,
so writing 0 as I suggested is correct.

>
> If not required I'll send the patch as you suggested.

Great! Thanks!

--Richard
