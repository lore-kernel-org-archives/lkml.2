Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1LMQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:26:38 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:21169 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149Ab1LMQ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:26:36 -0500
Message-ID: <4EE77C02.1000103@vmware.com>
Date: Tue, 13 Dec 2011 17:23:30 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com
Subject: Re: [PATCH] fixes to drm-next - TTM DMA code (v1)
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com> <20111213160753.GC2339@homer.localdomain>
In-Reply-To: <20111213160753.GC2339@homer.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 05:07 PM, Jerome Glisse wrote:
> On Mon, Dec 12, 2011 at 03:09:26PM -0500, Konrad Rzeszutek Wilk wrote:
>    
>> Jerome pointed me to some accounting error in the DMA API debugging code and
>> while I can't figure it out yet, I did notice some extreme slowness - which
>> is due to the nouveau driver calling the unpopulate (now that unbind +
>> unpopulate are squashed) quite a lot (this is using Gnome Shell - I think GNOME2
>> did not have those issues but I can't recall).
>>
>> Anyhow these patches fix the 50% perf regression I saw and also some minor bugs
>> that I noticed.
>>
>>      
> Gonna review those today and test them.
>
> Cheers,
> Jerome
>    
Hi!

I'm not whether any drivers are still using the AGP backend?
Calling unpopulate / (previous clear) each time unbind is done should be 
quite
inefficient with that one, as AGP sets up its own data structures and 
copies page tables
on each populate. That should really be avoided unless there is a good 
reason to have it.

/Thomas


