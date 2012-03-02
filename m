Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965599Ab2CBXkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:40:31 -0500
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:58712 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2CBXk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:40:29 -0500
Message-ID: <4F515A68.7040602@orcon.net.nz>
Date: Sat, 03 Mar 2012 12:40:24 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Henderson <rth@twiddle.net>, Michel Lespinasse <walken@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: alpha: futex regression bisected
References: <4F420256.2090600@orcon.net.nz>	<4F4282CA.5010502@twiddle.net>	<4F4B273C.9080506@orcon.net.nz> <20120302143615.2a272976.akpm@linux-foundation.org>
In-Reply-To: <20120302143615.2a272976.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sat, 03 Mar 2012 12:40:25 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Mar  3 12:40:26 2012
X-DSPAM-Confidence: 0.7005
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05GELEExM - 4bf2601d651d - 20120303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/12 11:36, Andrew Morton wrote:
> On Mon, 27 Feb 2012 19:48:28 +1300
> Michael Cree <mcree@orcon.net.nz> wrote:
> 
>>> There is no 32-bit compare instruction.  These are implemented by
>>> consistently extending the values to a 64-bit type.  Since the
>>> load instruction sign-extends, we want to sign-extend the other
>>> quantity as well (despite the fact it's logically unsigned).
>>>
>>> So:
>>>
>>> -        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
>>> +        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)
>>>
>>> should do the trick.
>>
>> Thanks, that fixes it.  Will you formally submit a patch with commit
>> message or should I?
>>
>> You can have at least a Reviewed-by, or even an
>> Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
>> who correctly analysed the problem in response to when I suggested the
>> fix on the debian-alpha email list without explanation.
> 
> Seems that I am an alpha hacker!  This?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: alpha: fix 32/64-bit bug in futex support

Thanks for attending to this!  Matt advises that he is still working on
getting his alpha-next queue back into action since the big kernel.org
hack so you picking it up is just the ticket.

Just to note that the futex fix fixes the glibc test suite failures and
the pulseaudio related crashes, but it does not fix the java compiiler
lockups that I was (and are still) observing. That is some other problem.

Cheers
Michael.
