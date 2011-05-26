Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab1EZNnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:43:24 -0400
Received: from mail.tpi.com ([70.99.223.143]:1609 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab1EZNnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:43:22 -0400
Message-ID: <4DDE58E9.1050307@canonical.com>
Date: Thu, 26 May 2011 07:43:05 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        airlied@redhat.com, lethal@linux-sh.org, james@albanarts.com,
        error27@gmail.com, randy.dunlap@oracle.com
Subject: Re: [PATCH] drivers: video: Remove useless checks
References: <20110519182702.GA3337@maxin>	<4DDCFA6F.2020801@canonical.com> <BANLkTinaVB-Y3kVzU9vHYUJs5P7Ea_JhOg@mail.gmail.com>
In-Reply-To: <BANLkTinaVB-Y3kVzU9vHYUJs5P7Ea_JhOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 03:30 AM, Maxin B John wrote:
> Hi,
>
> On Wed, May 25, 2011 at 1:47 PM, Tim Gardner<tim.gardner@canonical.com>  wrote:
>> On 05/19/2011 12:27 PM, Maxin B John wrote:
>>>
>>> Comparing unsigned less than zero will never be true.
>>> Removing similar checks from 'fbmem.c' and 'fbcmap.c'.
>>
>> Looks right to me, though there are other places that suffer from the same
>> issue. See fb_set_cmap() and its use of 'int start' and cmap->start.
>
> Thank you very much for reviewing the patch. As per your suggestion, I
> have checked
> the scenario is fb_set_cmap() and the use of 'int start' and 'cmap->start'.
>
> IMHO, that scenario doesn't fall under the comparison of unsigned int
> <  0. That scenario
> looks similar to the below given code to me:
> /*---------------------------------*/
> #include<stdio.h>
>
> int
> main ()
> {
>    unsigned int u_int = -1;
>    int s_int = 0;
>    s_int = u_int;
>    if (s_int<  0)
>      printf ("s_int is less than 0\n");
>    return 0;
> }
> /*---------------------------------*/
>
> Please let me know your comments.
>
> Best Regards,
> Maxin
>

IMHO mixing signed and unsigned comparisons like this is just wrong. Its 
unnecessarily complicated and misleading, especially for a device 
driver. I'm a firm believer in the KISS philosophy for driver development.

Its likely that the reason the fb code got into this situation is 
because a type was changed from signed to unsigned whence long ago, and 
nobody has bothered to clean it up.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
