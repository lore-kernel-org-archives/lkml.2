Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0EAJyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 05:54:20 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35475 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0EAJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 05:54:18 -0400
Message-ID: <4BDBFA44.5080203@in.ibm.com>
Date: Sat, 01 May 2010 15:24:12 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: -next Apr 30: OOPS during eHEA driver initialization
References: <4BDAF376.4030005@in.ibm.com> <4BDB12FB.5060806@in.ibm.com> <n2kfa686aa41004301035p7e15c017u7a1b98389cc1e466@mail.gmail.com> <g2mfa686aa41004301043i138ffb2dmac5b641fa3d512c4@mail.gmail.com>
In-Reply-To: <g2mfa686aa41004301043i138ffb2dmac5b641fa3d512c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Fri, Apr 30, 2010 at 11:35 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>   
>> On Fri, Apr 30, 2010 at 11:27 AM, Sachin Sant <sachinp@in.ibm.com> wrote:
>>     
>>> Sachin Sant wrote:
>>>       
>>>> With today's next eHEA drivers fails to initialize.
>>>>         
>>> If i revert the following patch eHEA network interface is initialized
>>> properly.
>>>
>>> commit cebfe0b6709abdab997c1a00499d67efa32ee1f0
>>> drivercore: Add of_match_table to the common device drivers
>>>       
>> That is an easy one to fix.  I'll get it updated today and send you the result.
>>     
>
> Let me know if this patch fixes it:
>   
Works for me. Thanks Grant. 

Tested-by : Sachin Sant <sachinp@in.ibm.com>

Regards
-Sachin


> Cheers,
> g.
>
> diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
> index ce957a4..693b0e6 100644
> --- a/arch/powerpc/kernel/ibmebus.c
> +++ b/arch/powerpc/kernel/ibmebus.c
> @@ -201,6 +201,9 @@ static int ibmebus_create_devices(const struct
> of_device_id *matches)
>
>  int ibmebus_register_driver(struct of_platform_driver *drv)
>  {
> +	if (!drv->driver.of_match_table)
> +		drv->driver.of_match_table = drv->match_table;
> +
>  	/* If the driver uses devices that ibmebus doesn't know, add them */
>  	ibmebus_create_devices(drv->driver.of_match_table);
>
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

