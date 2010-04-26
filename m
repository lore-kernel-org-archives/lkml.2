Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0DZO7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab0DZO7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:59:30 -0400
Message-ID: <4BD5A8B7.4050208@zytor.com>
Date: Mon, 26 Apr 2010 07:52:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is
 no 	VGA device in the system
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>	 <4BD55E85.4020709@cs.helsinki.fi>	 <20100426140535.GA17135@ericsson.com> <j2l84144f021004260735ib574b5f1t6c00a3a8a8f886ee@mail.gmail.com>
In-Reply-To: <j2l84144f021004260735ib574b5f1t6c00a3a8a8f886ee@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 07:35 AM, Pekka Enberg wrote:
>>>
>>> Wouldn't it be better to switch to, say, serial console here to avoid
>>> the NULL check in early_printk()?
>>>
>> This would be another possibility.
>>
>> However, since the serial console was not explicitly selected, it would possibly
>> not be initialized. My understanding is that Peter had a problem with that.
>>
>> One can argue that it would still be better to select the serial console in that case,
>> even though it might not be initialized. Actually, most likely it is (if it exists),
>> since the system must presumably have some means to communicate with the world.
>>
>> I am pretty much open to either option, if that results in the patch being accepted.
>> Just let me know which way to go.
> 
> Peter?

Yes, I really don't want to issue bytes to a serial port that isn't
known to be initialized; it could take a *very* long time even if the
port is actually present, and if the port *isn't* present it could hang
the kernel.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

