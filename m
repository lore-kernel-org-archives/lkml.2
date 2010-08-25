Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0HYVVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:21:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45204 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0HYVVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:21:16 -0400
Message-ID: <4C7588FB.4050001@zytor.com>
Date: Wed, 25 Aug 2010 14:19:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>
CC: Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema>
In-Reply-To: <20100825211257.GA636@pema>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 02:12 PM, Sebastien Hinderer wrote:
> Hi,
> 
>> excellent! Now if as the next step before inclusion you also add the usual DMI check
>> (as done by many drivers such as acerhdf etc.),
>> someone inexperienced who is dumb enough to enable it for his unrelated machine
>> will actually survive an otherwise raw I/O port access and poweroff
>> vector change ;))
> 
> The machine does not support DMI, I have mentionned that in the module.
> 

Perhaps a better questions is: what *do* they have?  I really don't feel
comfortable adding something like this which pokes at a random port in
the ISA range, especially with the Interrupt list listing 6 known other
uses of this particular port.

At that point I'd almost prefer doing something like a BIOS signature
check if we can't do anything better.

	-hpa
