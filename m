Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0GJV2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:28:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52608 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0GJV2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:28:54 -0400
Message-ID: <4C38E5D8.30408@zytor.com>
Date: Sat, 10 Jul 2010 14:27:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>	<4C38DCD3.8020302@kernel.org> <AANLkTikNSrb3-o4F5YVPs_dvGi5xdGqM-P6w7OBZm6aH@mail.gmail.com>
In-Reply-To: <AANLkTikNSrb3-o4F5YVPs_dvGi5xdGqM-P6w7OBZm6aH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 02:17 PM, Pekka Enberg wrote:
> Hi!
> 
> On Sat, Jul 10, 2010 at 11:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> can you analyze "console=uart8250,io,0x3f8,115200n8" instead?
>>
>> that is equal to "earlyprintk=ttyS0,115200 console=ttyS0,115200"
>>
>> so we only use one for all.
>>
>> also like to kill earlyprintk=ttyS0,115200 to favor earlycon
> 
> hpa, what's your take on this?
> 
> The 'console' variant seems overly complicated to me. We can add it
> but we also need to check for 'earlyprintk' as long as it's supported
> by the kernel.
> 

earlyprintk= seems to be preferred over console= these days.  Quite
frankly it's idiotic to have the user enter as many low-level details as
one has to do for the console= one.

Now, as for the I/O base, the I/O base for legacy serial ports are
available from a 4-element u16 array starting at absolute address 0x400.
 I don't think Linux currently examines that array -- instead relying on
the hard-coded values 0x3f8, 0x2f8, 0x3e8, 0x2e8 -- but it might
something to consider for the future.  However, we should match the
serial port subsystem there, of course.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

