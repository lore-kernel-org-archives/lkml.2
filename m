Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0CONcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:32:31 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:64666 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0CONc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GCisBE/RbSlytvzI7eSEpObIYMwFknxAZElpPNDycXHovqvL720FnfID2xrjRA47XK
         5QrrpUYhJDGaFhjcR4YpR+8OW4iyfXpQr0Pg4RcDt24k1WfwjfRfRj7m/BO649FixUQE
         sfRuIA2pZiiGFktgJkff7ZyEjROBYNhNxPhr4=
Message-ID: <4B9E3747.9060400@gmail.com>
Date: Mon, 15 Mar 2010 14:33:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: linux-serial@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
References: <4B532CF5.7080000@gmail.com> <20100117181702.026269e9@lxorguk.ukuu.org.uk> <4B535ED8.2050703@gmail.com> <4B9E0160.5000900@pelagicore.com>
In-Reply-To: <4B9E0160.5000900@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard, 

>>       if (mctrl&  TIOCM_RTS)
>>           iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
>>       else
>> -        iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
>> +        iowrite8(TIMBUART_CTRL_CTS, port->membase + TIMBUART_CTRL);
> 
> This is not completely correct. CTS is a read only bit and we are to
> stop signal RTS. So the line should look like:
> iowrite8(0, port->membase + TIMBUART_CTRL);

It appears as if this will also unset TIMBUART_CTRL_CTS (which is
probably ok since it's read-only) but TIMBUART_CTRL_FLSHTX and
TIMBUART_CTRL_FLSHRX as well. If undesired we need something like this:

iowrite8(ioread8(port->membase + TIMBUART_CTRL) & ~TIMBUART_CTRL_RTS,
	port->membase + TIMBUART_CTRL);

If not required I'll send the patch as you suggested.

Regards, Roel
