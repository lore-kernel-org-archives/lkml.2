Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab0HLUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:41:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58962 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab0HLUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lrPYQHVsAEdyrEL4ADb0dz/XtAvZN1rHGlgsL0Mmkz46bf4ghuXNJDNQ0SKKbfQkI4
         FHOk/8W20eTr21qNJEsxwa+funXfRes8fMPlRBLL7vB7bz50kjwfrYLvCzg550wcNmvS
         d1GuGpP1HDhM39i9Qe6ufCLbRU7EWb3TkY5s4=
Message-ID: <4C645C7D.1050903@lwfinger.net>
Date: Thu, 12 Aug 2010 15:41:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
References: <4C64571F.6000606@lwfinger.net> <AANLkTi==5umTtLWSoLfLPjHYAVpnPNHN-uzq7q2t-nfr@mail.gmail.com>
In-Reply-To: <AANLkTi==5umTtLWSoLfLPjHYAVpnPNHN-uzq7q2t-nfr@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 03:26 PM, Linus Torvalds wrote:
> On Thu, Aug 12, 2010 at 1:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> With the above commit, building an i386 version of the kernel results in the
>> following from the build:
>>
>> kernel/built-in.o: In function `logarithmic_accumulation':
>> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
>> `__umoddi3'
>> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
>> `__udivdi3'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> Reverting the patch allows the system to build correctly.
> 
> Damn. It's your compiler turning a while-loop into a divide. Which
> likely isn't even an optimization, but whatever.
> 
> John: I think that while-loop needs to be something like
> 
>    if (raw_nsecs >= NSEC_PER_SEC) {
>       u64 raw_secs = raw_nsecs;
>       raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
>       raw_time.tv_sec += taw_secs;
>   }
>   raw_time.tc_nsec = raw_nsecs;
> 
> which is sad and overly complicated, but the simple thing seems to get
> messed up by the compiler.
> 
> Untested. Maybe I got the complex do_div() semantics wrong. Somebody
> needs to check.

I'll try it. The system with the problem has gcc (SUSE Linux) 4.3.2
[gcc-4_3-branch revision 141291]. That is on a 64-bit system cross compiling
with ARCH=i386.

The real 32-bit system with gcc (SUSE Linux) 4.5.0 20100604 [gcc-4_5-branch
revision 160292] builds OK. It just wasn't finished when I wrote the first message.

Larry

