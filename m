Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1GSN6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab1GSN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:58:32 -0400
Message-ID: <4E258D7D.4000801@redhat.com>
Date: Tue, 19 Jul 2011 09:58:21 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk> <20110719132157.GG8006@one.firstfloor.org> <4E25892C.8070102@redhat.com> <20110719134645.GI8006@one.firstfloor.org>
In-Reply-To: <20110719134645.GI8006@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 09:46 AM, Andi Kleen wrote:
> On Tue, Jul 19, 2011 at 09:39:56AM -0400, Prarit Bhargava wrote:
>   
>> The DMI specification has not been updated since January of 2003.  It
>> has been replaced by SMBIOS.
>>     
>
> Yes of course, but dmidecode and the current DMI layer implements
> both anyways, don't they? (ok if you don't count the dynamic interfaces)
>
> The tables are very similar, there are just more entries in SMBIOS.
>   

That's not the way I understand it (at least from reviewing the two
different specifications).  DMI is not SMBIOS.  They are two very
different things -- we (linux kernel) have bastardized the name DMI and
really have been using the SMBIOS tables.  It is NOT a DMI implementation.

SMBIOS *CAN* contain a DMI table but saying that SMBIOS is DMI + a few
more tables is really a stretch IMO.

>   
>>     
>>>> 3.	Every other platform without DMI would benefit from the
>>>> 	interface being generic
>>>>     
>>>>         
>>> Can you expand on that? The information will be always system
>>> specific anyways. Do you really think there's that much commonality?
>>>
>>>   
>>>       
>> There seems to be some commonalities.  We have other arches checking for
>> model and vendor info.
>>     
> That's two fields out of hundreds. Does that need a common layer?
>   

> Right now I still fail to see the point of all of this.
>
> At some point I wanted a slightly more expansive sysfs interface for SMBIOS
> to avoid having to start mcelog as root for reading /dev/mem, but I don't
> think such a complicated approach is justified for that. What are 
> the other use cases?
>   

See my previous email re: type 15 structure and trying to jam it into
the existing dmi layer.

P.
> -Andi
>   
