Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1JSAe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:34:28 -0400
Received: from bfs011.mtl1.boxfabric.com ([74.117.141.19]:38343 "EHLO
	bfs011.mtl1.boxfabric.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1JSAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:34:28 -0400
X-Originating-IP: 173.35.101.49
Message-ID: <4E9E1B12.1090007@mark.mielke.cc>
Date: Tue, 18 Oct 2011 20:34:26 -0400
From: Mark Mielke <mark@mark.mielke.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: david@lang.hm
CC: David Rientjes <rientjes@google.com>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Appropriate use of sync() from user space?
References: <4E8CEECF.4050008@mark.mielke.cc> <20111018211446.GF4599@quack.suse.cz> <alpine.DEB.2.00.1110181652400.8149@chino.kir.corp.google.com> <alpine.DEB.2.02.1110181656360.28233@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1110181656360.28233@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 08:03 PM, david@lang.hm wrote:
> On Tue, 18 Oct 2011, David Rientjes wrote:
>> On Tue, 18 Oct 2011, Jan Kara wrote:
>>>> Quick summary: We have a vendor who is claiming that it is required
>>>> for their userspace program to execute sync(), and I am looking for
>>>> some sort of authoritative document or person to refer them to that
>>>> will state that this belief is incorrect and/or that this
>>>> architecture is not acceptable in a Unix environment.
>>>>
> also, you may want to check if they are really doing a 'sync' (syncing 
> the entire filesystem) or just a 'fsync' (syncing the file). Depending 
> on the technical depth of the people you are talking to, they may say 
> sync when what is actually happening is a fsync.
>
> there is little dispute that fsync is correct, but not a complete 
> answer to the issue. take a look at the LWN article on the subject at 
> http://lwn.net/Articles/457667

Thanks, Dave. Yes, the vendor is doing a real sync() - and is also doing 
a few fsync(). We managed to convince them that this is a defect through 
their sales channel as technical failed. Oh well.

I note that you say "there is little dispute that fsync is correct ..." 
- which I also would have assumed, but I found very little authoritative 
documents on this. I think it is just so "self evident" (which the 
exception that you state in ext3) that people don't tend to do this.

In the mean time, our users are literally doing "sync; cleartool mkview 
..." which forces most of the data out to disk before starting the 
vendor command, so that the IBM Rational "cleartool mkview" is able to 
complete successfully without timing out and failing after 3 to 5 
minutes. *sigh*

The problematic file seems to be a VMware Player mmap()'d file with size 
of 1 GByte or more. ClearCase "cleartool mkview" vs VMware Player normal 
operation. *sigh x 2*

Thanks,
mark

-- 
Mark Mielke<mark@mielke.cc>

