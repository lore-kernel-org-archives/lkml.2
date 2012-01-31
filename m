Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2AaCmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:42:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab2AaCmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:42:18 -0500
Message-ID: <4F2755A2.5040108@redhat.com>
Date: Tue, 31 Jan 2012 10:44:50 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add kernel parameter to disable module load
References: <20120128033450.GA2138@darkstar> <87vcnvbab1.fsf@rustcorp.com.au>
In-Reply-To: <87vcnvbab1.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2012 08:51 AM, Rusty Russell wrote:

> On Sat, 28 Jan 2012 11:34:50 +0800, Dave Young <dyoung@redhat.com> wrote:
>> Sometimes we need to test a kernel of same version with code or config
>> option changes.
>>
>> We already have sysctl to disable module load, but add a kernel
>> parameter will be more convenient.
> 
> 
>> +static int __init module_load_disable(char *str)
>> +{
>> +	modules_disabled = 1;
>> +	return 1;
>> +}
>> +__setup("nomodule", module_load_disable);
> 
> You misspelled core_param here :)
> 


Hello Rusty, If use core_param I'd better to change modules_disabled
from int to bool or we must pass nomodule=1 instead of simply pass
nomodule. But I think I can firstly post the core_param patch with
current int type, then work on the transition patch for the variable
type changes, what do you think?

Another do you think we need to expose this to sysfs via core_param?
According to the sysctl code looks like we should not add sysfs
interface to allow transition from "1" to "0"

-- 
Thanks
Dave
