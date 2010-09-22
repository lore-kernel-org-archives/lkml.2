Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0IVXRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:17:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0IVXRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:17:00 -0400
Message-ID: <4C9A8E4C.9030504@zytor.com>
Date: Wed, 22 Sep 2010 16:16:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221220.34066.bjorn.helgaas@hp.com> <4C9A4AAF.3030503@zytor.com> <201009221253.01049.bjorn.helgaas@hp.com> <4C9A51DC.5020009@zytor.com> <alpine.DEB.2.00.1009221541350.22070@chino.kir.corp.google.com> <4C9A881B.9010309@zytor.com> <alpine.DEB.2.00.1009221607590.22070@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1009221607590.22070@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 04:12 PM, David Rientjes wrote:
> On Wed, 22 Sep 2010, H. Peter Anvin wrote:
> 
>>> This patch is going to break our userspace parsing scripts if you change 
>>> the output format.  Admittedly, we're probably one of the few users who 
>>> actually parses this output, but we do have reasons to do it for our 
>>> firmware.  If there was some improvement being introduced here, we'd 
>>> happily handle multiple regexs (we constantly add new patterns when new 
>>> kernels are released), but I'm not seeing how this is better.
>>
>> Kernel messages are not an ABI or API.
>>
>> The user space API for this stuff is /sys/firmware/memmap.
>>
> 
> I'm referring to using [start, start + addr - 1] in the output, like 
> /sys/firmware/memmap does, as opposed to [start, start + addr].  Is it not 
> valuable to include the actual e820 map in some way, especially when you 
> have your own BIOS?  We've always used this output since it isn't 
> available later.

"The actual e820 map" contains (start, length, type) -- the end bracket
is not part of it at all.  Either way, /sys/firmware/memmap does provide
the memory map as provided by the firmware through whatever means.

> Another use of this information that people may already be using it for is 
> ensuring the memmap= on the command line is parsed correctly.
> 
> So, again, I'm looking for the benefit here in this patch and it's not 
> immediately apparent to me.

Consistency with other resources displayed seems like a major win to me.

	-hpa
	
