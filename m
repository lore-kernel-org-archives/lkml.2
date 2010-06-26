Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab0FZEHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 00:07:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40538 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0FZEHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 00:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PuQUJu/RVGxwfQHMIUDbcTKc0Ck9D5E9E+OC3wHUotgi9fiLQc0+xU3YpvmAln0Zfe
         /sFKxM9+/1zhXQLKO0T+U8wOMDsy4DnzHA5onIzpxkqA1b141YXmKetfur1XX1P/Yatu
         jPKBWauON2t2sXFXuctnjB3mi6xxsI//B0Rbs=
Message-ID: <4C257CEE.2070309@gmail.com>
Date: Fri, 25 Jun 2010 22:07:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch> <4C24C903.1070705@kernel.org> <4C24EED2.4020300@odi.ch>
In-Reply-To: <4C24EED2.4020300@odi.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 12:00 PM, Ortwin Glück wrote:
>
>
> On 25.06.2010 17:19, Tejun Heo wrote:
>> Patch attached, but please see below.
>
> Cheers, I will give it a try and provide feedback if "it" happens again.
>
>> Is it PATA?
>
> Yes. This chipset doesn't have SATA, only PATA.

Ahh, ok, it's not sata_nv at all then, it's pata_amd. On the same chip, 
totally different controller though.

PATA doesn't normally use hard-resets as a means of error recovery - 
that would mean hitting the RESET line, which I don't think most 
controllers can do on software command (it usually only gets asserted on 
power up or hitting the reset button), unlike on SATA where there's a 
defined way to trigger a COMRESET which is mostly equivalent. Also, that 
resets both devices on the channel, unlike soft reset which is specific 
to one device.

>
> CONFIG_ATA=y
> CONFIG_ATA_SFF=y
> CONFIG_SATA_NV=y
> CONFIG_PATA_AMD=y
>
>> Why do you have 2.01?
>
> for the DVD drive?
>
>> Can you please attach full boot
>> log?
>
> attached.
>
> Thanks.
>   Ortwin

