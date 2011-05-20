Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1ETDVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:21:31 -0400
Received: from mailhost.anl.gov ([130.202.113.50]:41534 "EHLO mailhost.anl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1ETDVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:21:30 -0400
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 23:21:30 EDT
Message-ID: <4DD5D9C9.3020000@mcs.anl.gov>
Date: Thu, 19 May 2011 22:02:33 -0500
From: Kazutomo Yoshii <kazutomo@mcs.anl.gov>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Kazutomo Yoshii <kazutomo.yoshii@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
Subject: Re: [bg-linux] [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>	<1305753895-24845-5-git-send-email-ericvh@gmail.com>	<1305851769.7481.90.camel@pasglop>  <4DD5C49E.4050103@gmail.com>	<1305857301.7481.121.camel@pasglop> <1305857610.7481.124.camel@pasglop>
In-Reply-To: <1305857610.7481.124.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 09:13 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2011-05-20 at 12:08 +1000, Benjamin Herrenschmidt wrote:
>    
>> On Thu, 2011-05-19 at 20:32 -0500, Kazutomo Yoshii wrote:
>>      
>>> Actually DMA sends invalidate requests to the snoop unit(L2 level).
>>> BGP SoC is a bit different from other 4xx base.
>>>        
>> Well, some other 44x also have a snooping L2 (more or less), but L1 is
>> usually the problem.
>>      
> Hrm... looking at the doco you pointed me to, it looks like the L1 -is-
> coherent, it gets snoop kills from the L2.
>    
Right, L1D is coherent if write throug is set.
L1I(virtually tagged) is not coherent, btw.

> Ok so we do need to make this non-coherent cache stuff a runtime option
> (well, we need that for 440+476 too anyways so may as well do it now).
>    
What sort of runtime option do you mean?

- kaz
> As for the alignment of kmalloc, it looks like a hack that should be
> done in the torus code itself.
>
> Cheers,
> Ben.
>
> _______________________________________________
> bg-linux mailing list
> bg-linux@lists.anl-external.org
> https://lists.anl-external.org/mailman/listinfo/bg-linux
> http://bg-linux.anl-external.org/wiki
>    

