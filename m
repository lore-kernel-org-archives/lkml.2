Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0CZAFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:05:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56587 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0CZAFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WI98K7HsGjX/sJ0ocZvB6eGIaLfbOedlwKGIPWCVyFWxKbSC5kwSBEbJlp58hMTdVN
         1PGWkYJk8k7MIMP4rTgQJKhRrZGs7LJZ3elEw6upKet0vUZfS7Rd9hBf0UarFgAXvO3B
         Poj+Sbb/6ska2Q0gZuJEDFeY6rJpdV0xXmGXo=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1003252334190.4413@axis700.grange>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
	 <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
	 <e9c3a7c21003251500r27077cci67b1f06727be97f1@mail.gmail.com>
	 <Pine.LNX.4.64.1003252334190.4413@axis700.grange>
Date: Thu, 25 Mar 2010 17:05:20 -0700
X-Google-Sender-Auth: b3f84d18b33fe75c
Message-ID: <e9c3a7c21003251705o63687fa5vfbe77ebeda8c0440@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 3:37 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 25 Mar 2010, Dan Williams wrote:
>
>> On Thu, Mar 25, 2010 at 1:58 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Thu, 25 Mar 2010, Linus Walleij wrote:
>> >
>> >> Convert the device_is_tx_complete() operation on the
>> >> DMA engine to a generic device_tx_status()operation which
>> >> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
>> >> DMA_TX_PAUSED.
>> >>
>> [..]
>> > General: you converted all drivers to the new .device_tx_status() API, but
>> > since they don't implement "residue," you left it uninitialised
>> > everywhere. Wouldn't it be better to set it to 0 or total length,
>> > depending on the complete / not complete status?
>>
>> Agree that it should not be uninitialized.  At the same time I do not
>> want to require drivers that don't need it to go through the hassle of
>> looking up a byte count, so perhaps all but the drivers that want this
>> support can return a 'max byte count'??
>
> Why not assign one of the two - 0 if the transfer is complete (DMA_SUCCESS
> status returned) or whatever max count otherwise? Except I do think this
> might confuse some users - seeing a residue larger than the total transfer
> length...
>

0 if complete makes sense and then the actual residue or all 0xf's to
indicate "I don't support inflight residue reporting".

--
Dan
