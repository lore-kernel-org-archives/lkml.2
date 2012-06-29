Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2F2O1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:27:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38559 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2F2O1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:27:15 -0400
Message-ID: <4FEDBB3C.7080105@acm.org>
Date: Fri, 29 Jun 2012 09:27:08 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andi Kleen <andi@firstfloor.org>, Srinivas_G_Gowda@Dell.com,
        tcminyard@gmail.com, linux-kernel@vger.kernel.org,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        jharg93@gmail.com
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com> <m2k3yrgf4d.fsf@firstfloor.org> <20120629123001.GA26545@srcf.ucam.org>
In-Reply-To: <20120629123001.GA26545@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:30 AM, Matthew Garrett wrote:
> On Thu, Jun 28, 2012 at 05:01:54PM -0700, Andi Kleen wrote:
>> Not sure that's all that useful. I can just see BMC's making the ACPI
>> mistake of trying to work around specific issues, by checking for
>> Linux.

I'm not sure I see that happening, but I suppose you never know.

>>
>> But since there are so many different Linux that will never work
>> because "Linux" does not describe a fixed release or code base.
>>
>> Probably dangerous.
> Agreed. Linux doesn't make interface guarantees to hardware, and where
> we've implied that we do it's ended up breaking things.
>

This is not really about making interface guarantees to hardware. This 
is more of a management discovery thing, so that system management 
software talking to the BMC can know what is running on the target.  
Something where management software can say "Hey, why is Linux running 
on that box? It's supposed to be BSD." or "That box has booted Linux but 
hasn't started its maintenance software". According to the spec, the 
information is supposed to be cleared if the system powers down or resets.

It seems to me that it's better to directly query what is running on the 
target to know what is running on it, but perhaps that's a security 
problem waiting to happen.  And perhaps it's better to have a small 
program set this at startup, since this operation will currently fail on 
the majority of systems out there.

-corey
