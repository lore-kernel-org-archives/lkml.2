Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1I3FPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:15:11 -0400
Received: from fnarfbargle.com ([93.93.131.224]:36984 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094Ab1I3FPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:15:10 -0400
Message-ID: <4E855050.8080403@fnarfbargle.com>
Date: Fri, 30 Sep 2011 13:14:56 +0800
From: Brad Campbell <lists2009@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Radeon regression fix
References: <4E847ED4.5090703@fnarfbargle.com>	<CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>	<4E848CDE.1020707@fnarfbargle.com>	<4E850BE6.2050306@fnarfbargle.com> <CADnq5_NJuGLWB-1d+TGqTxW6ZOOQ4QeQj1e6dXOffL5egZuw1g@mail.gmail.com>
In-Reply-To: <CADnq5_NJuGLWB-1d+TGqTxW6ZOOQ4QeQj1e6dXOffL5egZuw1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/11 12:59, Alex Deucher wrote:
> On Thu, Sep 29, 2011 at 8:23 PM, Brad Campbell

>> Looking at it with a nights sleep, it's obvious the code path in
>> aux_native_write is ok. Is this a bit cleaner than the last patch?
>
> Looks pretty good.  I was thinking of something more like this (sorry
> for the lack of a patch, I'm away from my source trees at the moment):
>
> 	while (1) {
> 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
> 					    msg, msg_bytes, recv, recv_bytes, delay,&ack);
>
> 		if (ret<  0)
> 			return ret;
> 		if ((ack&  AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
> 			return ret;
> 		else if ((ack&  AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
> 			udelay(400);
> 		else if (ret == 0)
> 			return -EPROTO;
> 		else
> 			return -EIO;
> 	}

Yep, that looks cleaner.

My only thought was the pre-3.0 code had a limit to the number of 
retries. Was that for a specific reason or is it ok to attempt to retry 
indefinitely if we receive a DEFER ?

>
> Thanks for tracking this down.

No worries. I learned quite a bit about some kernel internals and more 
than a few quirks about apple hardware while muddling around.
