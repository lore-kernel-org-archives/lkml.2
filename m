Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2IDIsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:48:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49154 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2IDIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:48:52 -0400
Message-ID: <5045C06F.4000507@gmail.com>
Date: Tue, 04 Sep 2012 16:48:47 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Xin Tong <xerox.time.tech@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux page table
References: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com> <alpine.LRH.2.00.1209021005090.22050@twin.jikos.cz> <CALKntY1XnHG7BAnu4yYU_8iwDttAhuxqu1bBu7YuxXMP4nF+JQ@mail.gmail.com> <alpine.LNX.2.00.1209022026100.20709@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1209022026100.20709@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 02:26 AM, Jiri Kosina wrote:
> On Sun, 2 Sep 2012, Xin Tong wrote:
>
>>>> 3. can two different processes have their CR3 being the same value
>>>> even though they have different first level page tables ?
>>>
>>> Yes, if they are created by clone(CLONE_VM). In such case they share the
>>> same mm_struct, and therefore mm_struct->pgd (which is exactly what is
>>> loaded into cr3 in switch_mm()) is the same.
>>>
>>
>> Is this the COW mechanism in linux. what if the cloned process need to
>> have set of its own pages later. do the CR3s for the 2 processes
>> become different at that point ?
>
> That is a different story. COW is applied on fork() (i.e. spawning new
> process), not on clone(CLONE_VM) (i.e. spawning new thread).
>

Yeah, and unshare(2) does not implement the flag that reverses the 
effects of CLONE_VM.

