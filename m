Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1BGSG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:06:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33340 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1BGSGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:06:25 -0500
Message-ID: <4D50343E.1020906@kernel.org>
Date: Mon, 07 Feb 2011 10:04:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com> <alpine.DEB.2.00.1102041130060.7277@kaball-desktop> <4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1102071524140.7277@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D503489.0020,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 08:50 AM, Stefano Stabellini wrote:
> On Sun, 6 Feb 2011, Yinghai Lu wrote:
>> On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
>>> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>>>> why not just move calling cleanup_highmap down?
>>>>
>>>> something like attached patch.
>>>
>>> This patch looks very clean and looks on the surface of it like it is
>>> removing some ugly ad hoc code, but (as always) it needs a description
>>> about the problem it solves and why it is correct.
>>
>> Sure.
>>
>>
>> Jeremy and xen guys, can you please check if it works well with xen ?
>>
> 
> Actually this patch makes things worse on xen, because before
> cleanup_highmap() wasn't called at all on xen (on purpose) and now it
> is, fully destroying all the mappings we have at _end.
> 
> Can we add a check on memblock reserved regions in cleanup_highmap()?
> Otherwise could we avoid calling cleanup_highmap() at all on xen?

why DO xen need over-mapped kernel initial mapping?

what is in that range after _end to 512M?

Yinghai
