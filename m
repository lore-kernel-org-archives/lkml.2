Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2GDRlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 13:41:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35042 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GDRlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:41:18 -0400
Message-ID: <4FF48039.3020505@acm.org>
Date: Wed, 04 Jul 2012 12:41:13 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Srinivas_G_Gowda@Dell.com, tcminyard@gmail.com, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        jharg93@gmail.com
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com> <m2k3yrgf4d.fsf@firstfloor.org> <20120629123001.GA26545@srcf.ucam.org> <4FEDBB3C.7080105@acm.org> <4FF3D090.8000403@dell.com> <20120704121726.GP11413@one.firstfloor.org>
In-Reply-To: <20120704121726.GP11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 07:17 AM, Andi Kleen wrote:
>> Rather than just have a static entry such as 'Linux' I could probably write the version number and more(distro name etc.. )
>>
>> Thoughts.. ?
> I still think "Linux" means nothing even to the management software.
> What should it do with that?
>
> If you provide some way for a distro to fill in "foobar linux 1.2.3.4"
> maybe. But just Linux or even Linux x.y.z would be wrong because the same kernel
> version can behave very differently.
>
> But it would be  better to define specific feature flags for
> specific needs that actually mean something.

I think the conclusion I have come to is that this really belongs as a 
small program that runs at startup.  That's not significantly different 
than having it done in the driver.  I can help you write it, if you like.

I think Andi is right here.  "Linux" may mean something to your 
management software.  Some other management software may want "Linux 
x.y.z".  Another may want "SuSE Enterprise Linux x.y".  It's impossible 
to be general enough in the kernel.

>
>> I know there were some concerns with the security aspect, Can you please let me know what kind of security holes we could be looking at ?
> I don't think there are any security problems. just forward/backward
> compatibility problems, as the ACPI experience shows.

I had mentioned possible security issues with having some daemon that 
identified the system directly over IP.  I don't think there are any 
issues with IPMI, at least not any more than you already have with IPMI, 
and it's reasonably secure for what it does.

-corey
