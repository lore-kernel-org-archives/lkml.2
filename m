Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0FHV6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:58:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55787 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0FHV6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:58:17 -0400
Message-ID: <4C0EBCE1.2070609@zytor.com>
Date: Tue, 08 Jun 2010 14:57:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>, Ingo Molnar <mingo@elte.hu>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>	<4C0E949D.6090002@zytor.com>	<20100608190848.GD25985@elte.hu>	<201006082122.25089.linux@rainbow-software.org> <20100608225656.7f645621@lxorguk.ukuu.org.uk>
In-Reply-To: <20100608225656.7f645621@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 02:56 PM, Alan Cox wrote:
>>> I agree that dis-using <1M by default is probably the sanest option.
>>
>> But please limit it to newer systems only (DMI present && year > 200?). There 
>> are many old machines running fine. Losing 1MB from 16MB is a bad thing.
> 
> Losing the low 1MB is bad thing anyway for things like firmware flashing
> and other weird crap that needs low pages (floppy controllers etc).
> 
> Losing 64K (but reporting corruption in it in a big scary way) is
> probably sensible for distributions, but its a config item so its policy
> so that wouldn't be a problem.
> 
> It has to be painful to the vendors so they get complaints, reports and
> support call costs. Otherwise they won't have the correct incentives to
> fix their mess.

We have already functionally lost 64K on all existing machines... I
think the current blacklist covers 90% or more of all systems in
existence, and we keep filling in the few holes that remain.

Adding the remaining half-megabyte of RAM really shouldn't be done
unconditionally, but as I said it could plausibly be reserved for
ZONE_DMA only.

	-hpa

