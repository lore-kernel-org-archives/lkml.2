Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0H3V4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:56:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45900 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0H3V4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kLwvgh91qRydtcM3Ciy44EcuEzKvMKKBSWuztAESKdb+fl75er4COwBPj3m0auYC+Q
         kuCQi7+nlVNGjheER2pw71FToxi8UUkZ3kLJVpGcHQmjuR7VFgAlR5SdJkpZUVG4rG9L
         5iwP9EeWpt8P3vzTmhQnAiBoOKPJBXZCY8bwY=
Date: Mon, 30 Aug 2010 14:55:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com,
        mcuos.com@gmail.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
Message-ID: <20100830215556.GC28865@core.coreip.homeip.net>
References: <4C7838DD.1020004@codeaurora.org>
 <201008271533.01542.dmitry.torokhov@gmail.com>
 <4C7BF6D2.5080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7BF6D2.5080501@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 02:22:10PM -0400, Neil Leeder wrote:
> On 8/27/2010 6:33 PM, Dmitry Torokhov wrote:
> >No, this is crazy... This is a twin-brother of the touchpad driver and
> >I really do not understand why chip claiming to have PS/2 interface
> >(3 ports if I were to believe the diagram) would not allow us talk to
> >the devices...
> 
> I didn't provide a key bit of information, sorry. The keyboard is
> not attached to the EC's PS/2 port. It is on a matrix of GPIOs.

And still you are using only one GPIO in your driver? While WPCE775x
does seem to have matrix keypad support I think that you are using one
of the 3 PS/2 ports, like your touchpad does.

> 
> I was trying to explain that even though the firmware on the EC uses
> 0xF4 written over i2c to initialize it, it doesn't appear to support
> other PS/2 commands directed to the keyboard on the GPIO matrix.
> 

The device is initialized with 0xf4; the device is supposed to respond
with 0xfa; I wonder what scancodes the device reports... It smells
strongly of PS/2.

Also, it is not controller that supports PS/2 commands but rather the
device itself so I am still hopeful that we could make use of the
standard drivers.

Wan, you worked at Nuvoton, do you know if wpce775 fully supports PS/2
interface? 

-- 
Dmitry
