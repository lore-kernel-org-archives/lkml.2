Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0FNPLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:11:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab0FNPLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:11:37 -0400
Message-ID: <4C164688.2030107@zytor.com>
Date: Mon, 14 Jun 2010 08:11:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com> <4C158BCF.6000303@jp.fujitsu.com> <alpine.LFD.2.00.1006140735040.11549@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1006140735040.11549@eddie.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 11:38 PM, Maciej W. Rozycki wrote:
> On Mon, 14 Jun 2010, Kenji Kaneshige wrote:
> 
>> - Architectural limit of physical address in x86 32-bit mode is 40-bit
>>   (depnds on processor version).
> 
>  According to documentation I happen to have handy this limit is actually 
> 52 bits (and space is currently available in the data structures used for 
> a possible future extension up to 63 bits).
> 

Yes.  There are, however, very likely bugs in several classes due to
incorrect bitmasks as well as 32-bit PFNs.

We have made the decision based on data structure limitations (and just
usability) to not support more than 2^36 bytes of RAM on 32 bits, but
those data structures should not affect I/O.  I;d like to track down and
fix the bugs instead of papering over the problem...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

