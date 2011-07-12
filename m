Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1GLVHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:07:16 -0400
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:43884 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1GLVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:07:14 -0400
Message-ID: <4E1CB768.6060304@genband.com>
Date: Tue, 12 Jul 2011 15:06:48 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: MK <mk@cognitivedissonance.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
In-Reply-To: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2011 21:06:49.0685 (UTC) FILETIME=[9DD24050:01CC40D7]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18256.002
X-TM-AS-Result: No--15.898200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 02:16 PM, MK wrote:

> So I filed a glibc bug with fedora to that effect:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=720176
>
> In which Andreas Schwab points out (rightly or wrongly) that according
> to the /proc/cpuinfo from the slice, the processor actually does not
> support AVX.  However,  the "model name", "Intel(R) Xeon(R) CPU
> E31230", is according to this a Sandy Bridge processor with AVX:
>
> http://en.wikipedia.org/wiki/Sandy_Bridge#Server_processors
>
> And while I do not have access to the hardware, the provider is very
> unequivocal about the fact that these are Sandy Bridges, which
> apparently include AVX.
>
> So I am looking for a next step to take in debugging this.  The kernel
> used on the slice (nb, openVZ does not allow for rolling your own) is
> 2.6.32 built with gcc 4.1.2.  I think this may be prior to AVX support
> in the kernel and gcc, but the glibc is 2.13, which apparently includes
> it.
>
> Does anyone have any idea why I would get this identical backtrace, and
> a failed reproducer test, on hardware which supposedly supports AVX
> (but not according to the kernel in /proc/cpuinfo)?

For what it's worth, Intel says the E31230 supports AVX as well:

http://ark.intel.com/Product.aspx?id=52271

so it's interesting that /proc/cpuinfo doesn't mention it.  Certainly 
I'd consider that worth following up.


As far as I can tell, support for saving/restoring AVX registers was 
added in 2.6.30, but gcc 4.6 is needed for proper support to actually 
use the new instructions.  However, given that you're using openVZ then 
if there is a bug in the kernel all it would take is one VPS slice using 
code built with a new compiler.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
