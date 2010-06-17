Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0FQQVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:21:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64097 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab0FQQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=W4D/OYhLeW0a5HamJAvmy1DhSWCQRU/06M4DW2zrbKkyhZ8DiYFakyQHX2uoytIpQK
         /2vTiBpM5Vtvotu42YAIHxqYmZ2ZEhLjphLi52VLNNSz46bRG3VpperknO2kW7QElXja
         6fnKscaMEfiHUtZthiEDH4UktEtodB3V0cJBY=
Message-ID: <4C1A4B70.2010402@gmail.com>
Date: Thu, 17 Jun 2010 09:21:04 -0700
From: JD <jd1008@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: udevd high cpu hogging in kernel-2.6.34   git8 to git-13
References: <4BFF565C.3080108@gmail.com> <4BFF59B5.70002@gmail.com> <4BFF5D6C.3010207@gmail.com> <4BFF5E3B.5060305@gmail.com>
In-Reply-To: <4BFF5E3B.5060305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/27/2010 11:10 PM, Jiri Slaby wrote:
> Added lkml back to CC.
>
> On 05/28/2010 08:06 AM, JD wrote:
>    
>> But here goes:
>> I have seen this behaviour in all the git releases from git8
>> to the current 2.6.34-git13
>>
>> I have some of the analysis based on strace, and kernel stack
>> trace.
>> Instead of backing out the whole code for the new udevd, perhaps
>> it (udevd) should sleep for some time before polling the same fd
>> again.
>>      
> So if you see in the strace output the poll to return immediately with
> out fd being an anon_inode (check /proc/pid_of_udev/fd/), it is the
> issue. AFAIK, it was not fixed upstream yet.
>
> So could you try to revert a7cf4145b?
>
>    
As promised, I tested the patch submitted by Eric Paris
(See http://marc.info/?l=linux-kernel&m=127479018618584&w=2).
I patched kernel-2.6.34-git13 with it, without reverting a7cf4145b.
The thing is it works and works extremely well.
The behaviour is back to what it used to be: Only 3 udevd
threads, as in before git8, and they do not consume any
cpu bandwidth that I can see. It is well below the threshold
of 1% .

Also, it seems that it has been picked up by upstream. Compiled
and booted 2.6.34-git16 and all is well.

