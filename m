Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0FKBPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:15:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63100 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0FKBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pWWIh0CRsGGn8vsrNK/8K2/UTDYz3p0opv/5nf+kSNNN6A3SVWOfNVaEI+pmZuaMLs
         EURTDDnRSFRJhu86rmhDOl2+vBCySgKwZ6U4KWsL7vFhVbb1JF+tQbVLikb+8v8XpYYG
         hqbSpH3u9p2BDSLJhlbb014oy+lpWkoivef5U=
Message-ID: <4C118E2C.4070303@gmail.com>
Date: Thu, 10 Jun 2010 19:15:24 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ondrej Zary <linux@rainbow-software.org>, Ingo Molnar <mingo@elte.hu>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl> <4C0E949D.6090002@zytor.com> <20100608190848.GD25985@elte.hu> <201006082122.25089.linux@rainbow-software.org> <4C0EA8A1.4020801@zytor.com>
In-Reply-To: <4C0EA8A1.4020801@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 02:31 PM, H. Peter Anvin wrote:
> On 06/08/2010 12:22 PM, Ondrej Zary wrote:
>>>
>>> Yep, patterns of some silly OSD bitmap showed up in one of the corruption -
>>> firmware displaying a 'you inserted a cable' kind of icon somewhere and
>>> messing up the SMM code or so ...
>>>
>>> I agree that dis-using<1M by default is probably the sanest option.
>>
>> But please limit it to newer systems only (DMI present&&  year>  200?). There
>> are many old machines running fine. Losing 1MB from 16MB is a bad thing.
>>
>
> Disusing 64K is something we can do unconditionally (especially since
> we're only talking about 60K -- 15 pages -- of actually usable memory
> anyway.)
>
> Dropping all the low 0.6 MB (which is what it really is) is probably
> unacceptable by default, but perhaps it makes sense to use it only for
> ZONE_DMA or something.

According to the document, "Neither Windows Vista nor Windows 7 stores 
operating system code and data in the lowest 1 MB of physical memory, 
regardless of whether Windows is running on real or virtualized 
hardware", so doing the same in general might not be a bad thing (unless 
we have less than a certain amount of RAM).

They're also checksumming the low 1MB and writing an event log entry if 
corruption is detected after sleep events, so if WHQL tests start 
checking for that, maybe these bugs will start going away on new 
machines. Of course, on some machines the corruption apparently happens 
other times as well, so who knows..
