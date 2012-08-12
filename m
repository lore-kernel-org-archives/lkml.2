Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2HLCmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 22:42:32 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.74]:56981 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2HLCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 22:42:29 -0400
Message-ID: <50271811.9090006@orcon.net.nz>
Date: Sun, 12 Aug 2012 14:42:25 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        John David Anglin <dave.anglin@bell.net>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
References: <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com> <20120723114258.GV9222@suse.de> <20120723122905.GA22476@localhost> <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl> <20120724074844.GA9519@localhost> <BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl> <1343193053.3139.6.camel@dabdike> <CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com> <20120802150209.GA26601@localhost> <502707D5.7020602@orcon.net.nz> <20120812021013.GA8442@localhost>
In-Reply-To: <20120812021013.GA8442@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Sun, 12 Aug 2012 14:42:26 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Aug 12 14:42:27 2012
X-DSPAM-Confidence: 0.7622
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=G2; city=Porirua; latitude=-41.1333; longitude=174.8500; http://maps.google.com/maps?q=-41.1333,174.8500&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06HJCOVuR - 3206d0345793 - 20120812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/12 14:10, Fengguang Wu wrote:
> On Sun, Aug 12, 2012 at 01:33:09PM +1200, Michael Cree wrote:
>> On 03/08/12 03:02, Fengguang Wu wrote:
>>> On Thu, Jul 26, 2012 at 10:06:41AM -0700, Tony Luck wrote:
>>>> On Tue, Jul 24, 2012 at 10:10 PM, James Bottomley
>>>> <James.Bottomley@hansenpartnership.com> wrote:
>>>>>> Here is the line in sock.i:
>>>>>>
>>>>>> struct static_key memalloc_socks = ((struct static_key) { .enabled =
>>>>>> ((atomic_t) { (0) }) });
>>>>>
>>>>> The above line contains two compound literals.  It also uses a designated
>>>>> initializer to initialize the field enabled.  A compound literal is not a
>>>>> constant expression.
>>>>
>>>> Seeing the same thing on ia64 building next-20120726.  Same fix works
>>>> for me ... so I'll steal this whole changelog and attributes.
>>>
>>> I got the same error for alpha, the same fix applies.
>>
>> Just trying this patch on Alpha against v3.6-rc1 and it leads to new
>> compilation errors, namely:
>>
>> init/init_task.c:12: error: braced-group within expression allowed only
>> inside a function
>> init/init_task.c:13: error: braced-group within expression allowed only
>> inside a function
>> init/init_task.c:16: error: braced-group within expression allowed only
>> inside a function
>> init/init_task.c:16: error: braced-group within expression allowed only
>> inside a function
>> make[1]: *** [init/init_task.o] Error 1
> 
> Sorry! This will actually compile:
> 
> -#define ATOMIC_INIT(i)         ( { (i) } )
> +#define ATOMIC_INIT(i)         { (i) }

Thanks, it now compiles correctly.  I'm currently collecting Alpha
patches to send on to Linus so will include this one.

Cheers
Michael.
