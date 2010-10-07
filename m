Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0JGPcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:32:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50130 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0JGPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:32:34 -0400
Message-ID: <4CADE80E.8050905@zytor.com>
Date: Thu, 07 Oct 2010 08:32:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch disabling use of PSE on Atom CPUs with a certain	 erratum
References: <4CADAB3A020000780001B30A@vpn.id2.novell.com> <4CADCF23.5070800@zytor.com> <4CADEED9020000780001B44F@vpn.id2.novell.com> <4CADD442.4050706@zytor.com> <4CADFAE6020000780001B4DC@vpn.id2.novell.com> <4CADE2F3.8000908@zytor.com> <4CAE0373020000780001B50E@vpn.id2.novell.com>
In-Reply-To: <4CAE0373020000780001B50E@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 08:29 AM, Jan Beulich wrote:
>>
>> You're right... I misremembered.  The question is what to do at this
>> point, since we're already in trouble.  A possible failure on startup
>> seems better than a state in which we could get data corruption at
>> almost any time.
> 
> The only possible (afaict) way to address this would be to check for
> the erratum in the boot code, and establish 4k page mappings from
> the beginning. That's likely going to be ugly though.
> 

Well, I guess we could do on 64 bits what we do on 32 bits, and always
use 4K pages for the initial bootstrap, to then be coalesced if PSE is
supported.  Again, ugly.

> The main reason I was asking was not so much to trigger a code
> change, but to understand the implications (since both the comment
> in the code and the changeset comment don't really hint at this
> leaving a problem open for 64-bit), to some degree to understand
> whether e.g. Xen would also need such a workaround (if anyone
> cares to run Xen on Atoms).

Well, keep in mind that the right thing really is to get the microcode
update into the CPU early... i.e. in the BIOS, or in a pinch, from the
bootloader -- but before the kernel runs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

