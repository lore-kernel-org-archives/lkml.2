Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1C2PmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:42:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54374 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1C2PmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:42:09 -0400
Message-ID: <4D91F4BB.5090708@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:03:23 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: TPM chip prevents machine from suspending
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20110329080856.1726dfaa@tlielax.poochiereds.net> <4D91CF9D.3050500@linux.vnet.ibm.com> <4D91ED0C.8070503@linux.vnet.ibm.com>
In-Reply-To: <4D91ED0C.8070503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:30 AM, Rajiv Andrade wrote:
> On 03/29/2011 09:25 AM, Stefan Berger wrote:
>> On 03/29/2011 08:08 AM, Jeff Layton wrote:
>>>>> Is there some way short of recompiling with CONFIG_TCG_* turned off
>>> to disable the TPM driver at boot time?
>>>
>> As far as I know, 'no'. I'd defer it to the maintainers as to how they would want to solve your particular problem... either by using above work-around, which would be more transparent, or actively having to turn the driver off with a command line parameter.
>>
>>     Stefan
>>
> I'm handling a patch from Stefan that solves so, for now,
> I'd recommend to use Stefan's tool.

Well, at least none of the patches I submitted in the series solves this 
particular problem.

I am not sure whether this problem should be fixed since it's hopefully 
rare. If it was to be fixed, how it should be fixed. Here are a couple 
of options:

- declare it a lost case due to broken out-of-spec BIOS -- don't fix it; 
machine won't suspend a 2nd time

- send  a command to the TPM upon resume and if TPM response returns 
with error code 38 set a flag and don't send TPM_SaveState() upon the 
next suspend; log this case; the TPM becomes unusable; machine will 
suspend a 2nd time

- send a command to the TPM upon resume and if it returns with error 
code 38 send TPM_Startup(ST_STATE) -> this masks the BIOS problem; log 
this case; TPM stays usable; machine will suspend a 2nd time; a 
colleague tells me it may not be 'safe'

Options 2 and 3 would now also run for all the rest of the machines with 
a good BIOS...

    Stefan

