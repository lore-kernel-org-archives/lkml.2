Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab1CXS0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:26:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52588 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1CXS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E1uPDmv9fwhxXI7cGwH0y1auYHL+J56dfacExxElFVtHVI9ueysQKPRhjIFYQNxYJV
         6pgC5jjUVi2yL8An6vVPQk3bIePG4E+FoxBnv3nG87JLDrE6Qu4Dz6kEFU7YBhjeXjvE
         UzagU/oV4SwnEpJ2fQhg3FqlbQ7REir7NDadE=
Message-ID: <4D8B8CC4.8000500@gmail.com>
Date: Thu, 24 Mar 2011 21:26:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com> <20110324084819.GH30812@elte.hu> <4D8B6569.2030001@gmail.com> <20110324163332.GA2414@elte.hu> <4D8B7570.40101@gmail.com> <20110324182221.GF1239@redhat.com>
In-Reply-To: <20110324182221.GF1239@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 09:22 PM, Don Zickus wrote:
> On Thu, Mar 24, 2011 at 07:46:40PM +0300, Cyrill Gorcunov wrote:
>>>> The read of a proper MSR register was missed so instead of a counter the 
>>>> configration register is tested (it has ARCH_P4_UNFLAGGED_BIT always cleared) 
>>>> and unflagged overflows never have been catched. Fix it by reading a proper 
>>>> MSR register.
>>>
>>> So what effect does this have on the regular perf user? Please try to describe 
>>> the real-life effect of the bug/problem fixed here.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>
>> Unflagged overflows never have been catched due to missed read of a register which
>> is to signalize about it, and as result unknown nmi may happen leading to
>> "Dazen and confused" message. That is what supposed to be in changelog?
> 
> I think Ingo is looking for something like this:
> 

Thanks Don, if Ingo agree I can update it.

-- 
    Cyrill
