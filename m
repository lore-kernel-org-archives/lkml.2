Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1JCQ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:58:30 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:10926 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab1JCQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:58:25 -0400
Message-ID: <4E89E93B.1060707@vmware.com>
Date: Mon, 03 Oct 2011 18:56:27 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v1.8
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com> <4E8568E8.1070800@vmware.com> <20110930140949.GA18905@phenom.oracle.com> <4E89E45E.7010009@vmware.com> <20111003164606.GI17108@phenom.oracle.com>
In-Reply-To: <20111003164606.GI17108@phenom.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 06:46 PM, Konrad Rzeszutek Wilk wrote:
>
> It does now (I had a spinlock mishap).. which reminds me - how
> do I test these patches with your vmwgfx driver? I've an old version
> of VMWare Workstation 8, would that do?
>    

VMware workstation 8 is OK (it's actually the latest version of 
workstation).

You'd need the vmwgfx kernel, driver,
latest mesa master compiled with the "svga" driver and the "dri" and 
"xa" state trackers.
xf86-video-vmware, the "vmwgfx" branch.

And you should be fine running 3D.



>>      
>>> The swapping code back (so from swap to pool) does not seem to
>>> distinguish it that much - it just allocates a new page - and
>>> then copies from whatever was in the swap cache?
>>>
>>> This is something you were thinking to do in the future I presume?
>>>        
>> Yes. If / when I do that, I might be adding a new backend function
>> to put a ttm in an
>> "anonymous state", that is using only pages that can be inserted in
>> the swap cache or passed
>> around to other devices, and to put a ttm in a "device" state, that
>> copies it to device mappable pages.
>>      
> OK, that should be no trouble - we would need to expose a function
> call to "detach" the page from the TTM pool (which could mean
> actually allocating a new page for the "other" device, and copying
> it from the "source" to "other" and then freeing the "source).
>
> I am thinking ... you hotplug an high-end radeon while the machine has
> an ATI ES1000 in it, and want to move those pages to the new
> card. The ATI ES1000 can only do up to 4GB, while the new fancy card
> has no such limits (and perhaps does not want to use the TTM DMA
> pool).
>
> Is this what you had in mind?
>    
Yes, that's a typical use-case. Or passing pages between an array of 
GPGPUs...


>> Thanks,
>> /Thomas
>>      

/Thomas

