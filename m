Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0FDFev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:34:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39990 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0FDFeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=leB5SweKhdALpd4hU//sZL0egR/il1Csjd6RbG2kBLHpt28T7RyKvzWhslRFo2QIpk
         Ns0J2O2fMpK9XFdv4jEweMIz2SxpUUPwtZMHE9J+9Uif53AwFC6eYF5uwz8P2rTO4Gkj
         vEtuoT1ROAaz76HWrZ04A0eYzcwHULwelbrH0=
Message-ID: <4C089068.4070407@gmail.com>
Date: Fri, 04 Jun 2010 13:34:32 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michael Ellerman <michael@ellerman.id.au>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>  <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>  <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>  <87d3w9582z.fsf@deeprootsystems.com>  <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org> <1275536698.22020.81.camel@concordia> <alpine.LFD.2.00.1006022112320.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006022112320.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 12:26 PM, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Jun 2010, Michael Ellerman wrote:
>>
>> You can sort of do that today, by just storing a delta, but oldconfig
>> will silently turn off things you have enabled if prereqs change, so
>> that doesn't really work I think.
> 
> I think you can do it today with various hacks. Up to and including 
> basically doing something that just selects the options you want.
> 
> IOW, you could likely have a human-written Kconfig.<platform> file that 
> just does 
> 
> 	define_bool MYPLATFORM y
> 		select .. everything I need ..
> 
> 	include Kconfig.main
> 
> or a number of other tricks.
> 
> Ingo and the x86 folks (who I really think have done a very good job, and 
> there really aren't any crazy defconfig files there) have this "make 
> randconfig" together with scripted requirements so that you can actually 
> _boot_ the random config, just because the requirements make sure that the 
> things needed for booting on the test setup are selected.
> 
> I forget exactly what the build setup there is (Ingo described it to me 
> long time ago, but since I don't even want to have a build farm in my 
> home, I didn't care much).
> 
> But we certainly _can_ do a better job than the 'defconfig' thing that was 
> really never meant for the kind of use it sees in ARM/POWERPC/SH/MIPS, and 
> that really isn't appropriate for any manual editing (so people just run 
> "make oldconfig" with tweaking or something, and then use the newly 
> generated file).
> 

It certainly looks a better way to handle this. However, considering the
facts that there are so many platforms out there, and doing a transition
without breaking any of them is a lot work, it's actually easier to just
reduce the number of defconfig at this moment, provided that most ARM
platforms with the same SoC are able to be built into a single kernel.
There are some exceptions though, I'd suggest not to introduce any other
defconfig for these platforms until their problem is solved.

Russell has setup a thread for this issue in linux-arm-kernel ML, so
hopefully there will be a lot patches around to address it.

There are some specific problems with ARM, e.g. some platforms are really
not maintained for a long time, and even no way to find someone or some
machine to test. And even with one defconfig per SoC, there could still
be about > 60 defconfigs there (compared with 178 at this moment).

> And I suspect that it really is best to just remove the existing defconfig 
> files. People can see them in the history to pick up what the heck they 
> did, but no way will any sane model ever look even _remotely_ like them, 
> so they really aren't a useful basis for going forward.
> 
> But don't worry. It didn't happen this merge window, obviously.
> 
> 		Linus

