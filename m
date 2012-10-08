Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JHLdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:33:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2JHLdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:33:42 -0400
Message-ID: <5072BA10.8080100@gmail.com>
Date: Mon, 08 Oct 2012 19:33:36 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jonathan Nieder <jrnieder@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>  <20121004174626.GB14301@kroah.com> <1349375519.14388.16.camel@twins>  <20121004222755.GC3609@kroah.com> <1349432466.14388.25.camel@twins>  <20121005171007.GC15867@elie.Belkin> <1349457799.14388.52.camel@twins>
In-Reply-To: <1349457799.14388.52.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 01:23 AM, Peter Zijlstra wrote:
> On Fri, 2012-10-05 at 10:10 -0700, Jonathan Nieder wrote:
>> Peter Zijlstra wrote:
>>> On Thu, 2012-10-04 at 15:27 -0700, Greg Kroah-Hartman wrote:
>>
>>>> I'm puzzled as well.  Any ideas if I should do anything here or not?
>>>
>>> So I think the current v3.5.5 code is fine.
>>
>> Now I'm puzzled.  You wrote:
>>
>> | However, since we don't restart the tick, we won't be sampling load muck
>> | and calling calc_load_exit_idle() from there is bound to confuse state.
>>
>> Doesn't that mean 900404e5d201 "sched: Add missing call to
>> calc_load_exit_idle()" which is part of 3.5.5 was problematic?  Or
>> did I just miscount the number of "not"s?
>
>
> Argh, yeah, so now I've managed to confuse everyone I'm afraid.
>
> You are right, v3.5.5 has one calc_load_exit_idle() too many, the one in
> tick_nohz_update_jiffies() needs to go.
>
> Sorry.. I got entirely confused figuring out wth happened with 3.6.
>
High loadavg reported with v3.6, and I just checked the upstream code, 
which puzzled many people. Sorry for that~
