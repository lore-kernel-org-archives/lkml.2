Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0I0Xew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:34:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33892 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab0I0Xev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:34:51 -0400
Message-ID: <4CA129EB.5000309@zytor.com>
Date: Mon, 27 Sep 2010 16:34:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: caiqian@redhat.com, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com> <4CA12976.5060504@kernel.org>
In-Reply-To: <4CA12976.5060504@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 04:32 PM, Yinghai Lu wrote:
> On 09/27/2010 04:26 PM, H. Peter Anvin wrote:
>> On 09/27/2010 04:20 PM, Yinghai Lu wrote:
>>>
>>> x86 own version for find_area?
>>>
>>
>> No, double no.
>>
>> Same kind of crap: overloading an interface with semantics it shouldn't
>> have.  The right thing is to introduce a new interface with carries the
>> explicitly needed policy with it... e.g. memblock_find_in_range_lowest().
>>
>> That interface would have the explicit semantics of returning the lowest
>> possible address, as opposed to any suitable address (which may change
>> if policy requirements change.)
>>
>> The other question is why does kexec need this in the first place?  Is
>> this due to a design bug in kexec or is there some fundamental reason
>> for this?
> 
> bzImage is used here. so need range below 4g.
> 

OK, so why don't you cap the range to 4 GiB and then pass that down to
the existing interface?  That's different from "lowest possible address".

	-hpa

