Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2BIOn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:43:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52399 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2BIOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:43:25 -0500
Message-ID: <4F33DB88.2080209@gmail.com>
Date: Thu, 09 Feb 2012 07:43:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data
 on a VM
References: <4F32A907.6030505@gmail.com> <20120208174434.GI22598@amd.com> <4F32B680.3090502@gmail.com> <20120208175709.GK22598@amd.com> <20120209073024.GA18010@elte.hu> <20120209111451.GM22598@amd.com> <20120209133446.GD8830@elte.hu>
In-Reply-To: <20120209133446.GD8830@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 06:34 AM, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
>> On Thu, Feb 09, 2012 at 08:30:24AM +0100, Ingo Molnar wrote:
>>>
>>> * Joerg Roedel <joerg.roedel@amd.com> wrote:
>>>
>>>>> which makes sense. It forces 
>>>>> perf_session__find_machine_for_cpumode() to return the host 
>>>>> machine always.
>>>>
>>>> Great, thanks. I will send two patches tomorrow to fix Jason's 
>>>> problem and change the default for perf_guest.
>>>
>>> Well, if the crash is fixed then the the default can stay, 
>>> right?
>>
>> David's crash is fixed by changing the default back to its 
>> original value :)
> 
> Then that's the wrong fix really.

You can't enable perf_guest unless guest info has been configured as
done with perf-kvm.

The problem is triggered in perf_session__find_machine_for_cpumode(). If
perf_session__find_machine() is changed to
perf_session__findnew_machine() you get into machines__findnew() which
shows the root cause: the event is for a VM but symbol_conf.guestmount
is not set.

So, really perf_guest cannot be enabled unless guest info has been given.

David
