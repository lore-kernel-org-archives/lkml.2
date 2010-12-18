Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0LRXcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 18:32:52 -0500
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:35880 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0LRXcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 18:32:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=caeuWIahucq3wcmSdRc7Iuzafo2XtU3vLu+FNDt55uDjj9oNofFMVOiV1HXkT5D1;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D0D44A1.8090501@earthlink.net>
Date: Sat, 18 Dec 2010 18:32:49 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: I915 driver locks up
References: <4D0D1516.3040404@earthlink.net> <4D0D19FF.4020600@earthlink.net> <5b55a1$j0av6h@fmsmga002.fm.intel.com>
In-Reply-To: <5b55a1$j0av6h@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec792a6045004676219dcaa965a034df12da350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 04:40 PM, Chris Wilson wrote:
> On Sat, 18 Dec 2010 15:30:55 -0500, Stephen Clark<sclark46@earthlink.net>  wrote:
>    
>> On 12/18/2010 03:09 PM, Stephen Clark wrote:
>>      
>>> Hi,
>>>
>>> I am using 2.6.35.9-64.fc14.x86_64 running 1.3.9-1.fc14.x86_64
>>> and am having my 945gma lock up in texture decompress according
>>> to intel_gpu_top utility, when trying to play Myst 5.
>>>
>>> Any fixes on the horizon?
>>>
>>>        
>> Additional data point with 2.6.37-0.rc6.git0.1.fc15.x86_64 from rawhide
>> I get:
>> [  307.256028] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>> elapsed... GPU hung
>> [  307.258118] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
>> returns -11 (awaiting 27197 at 27195, next 27199)
>> [  307.258975] [drm:i915_reset] *ERROR* Failed to reset chip.
>>
>> and my X screen goes weird - have to switch to vty console.
>>      
> Judging by your description, you've hit a bug in Mesa. Please verify the
> bug with the current stable release (of Mesa) and file a bug report, and
> be sure to include /sys/kernel/debug/dri/0/i915_error_state for the hang.
>
> Thanks,
> -Chris
>
>    
I had been using mesa-7.9.
I loaded mesa-7.10 similar results. There is no

/sys/kernel/debug/dri/0/i915_error_state

In fact there is nothing in the /sys/kernel/debug directory. Do I have 
to enable
something.

With the later kernel - things are worse X becomes totally useless it looks
like my lcd panel lost horizontal sync. With the 2.6.25 kernel X is 
still usable
this makes me think at least some of the problem is kernel related.

With 2.6.37-rc6 and mesa 7.10 with hardware acceleration turned off in wine-

Dec 18 18:01:50 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.x86_64
Dec 18 18:01:52 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.i686
Dec 18 18:01:54 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.x86_64
Dec 18 18:02:02 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.x86_6
4
Dec 18 18:02:03 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.i686
Dec 18 18:02:11 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.i686
Dec 18 18:04:18 joker4 kernel: [ 9603.588113] [drm:i915_hangcheck_elapsed] *ERRO
R* Hangcheck timer elapsed... GPU hung
Dec 18 18:04:18 joker4 kernel: [ 9603.588313] [drm:i915_do_wait_request] *ERROR*
  i915_do_wait_request returns -5 (awaiting 379738 at 379735)


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



