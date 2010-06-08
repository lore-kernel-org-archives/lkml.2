Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0FHUbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:31:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab0FHUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:31:49 -0400
Message-ID: <4C0EA8A1.4020801@zytor.com>
Date: Tue, 08 Jun 2010 13:31:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Ingo Molnar <mingo@elte.hu>, Yuhong Bao <yuhongbao_386@hotmail.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl> <4C0E949D.6090002@zytor.com> <20100608190848.GD25985@elte.hu> <201006082122.25089.linux@rainbow-software.org>
In-Reply-To: <201006082122.25089.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 12:22 PM, Ondrej Zary wrote:
>>
>> Yep, patterns of some silly OSD bitmap showed up in one of the corruption -
>> firmware displaying a 'you inserted a cable' kind of icon somewhere and
>> messing up the SMM code or so ...
>>
>> I agree that dis-using <1M by default is probably the sanest option.
> 
> But please limit it to newer systems only (DMI present && year > 200?). There 
> are many old machines running fine. Losing 1MB from 16MB is a bad thing.
> 

Disusing 64K is something we can do unconditionally (especially since
we're only talking about 60K -- 15 pages -- of actually usable memory
anyway.)

Dropping all the low 0.6 MB (which is what it really is) is probably
unacceptable by default, but perhaps it makes sense to use it only for
ZONE_DMA or something.

	-hpa
