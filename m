Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0ETSgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:36:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41512 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0ETSgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:36:15 -0400
Message-ID: <4BF580ED.3080207@oracle.com>
Date: Thu, 20 May 2010 11:35:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: NR_CPUS configuration option wrong
References: <ht3rr8$b5f$2@dough.gmane.org> <20100520103851.8e051a3f.randy.dunlap@oracle.com> <4BF58054.8060601@kingswood-consulting.co.uk>
In-Reply-To: <4BF58054.8060601@kingswood-consulting.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF5811A.001D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/10 11:32, Frank A. Kingswood wrote:
> Randy Dunlap wrote:
>> On Thu, 20 May 2010 18:34:32 +0100 Frank A. Kingswood wrote:
>>
>>> Hi!
>>>
>>> The configuration MAXSMP help text indicates it is used to enable
>>> configuration of number of CPUs. However, NR_CPUS depends on !MAXSMP.
>>>
>>> arch/x86/Kconfig:
>>> 758 config NR_CPUS
>>> 759         int "Maximum number of CPUs" if SMP && !MAXSMP
>>
>> That line depends on !MAXSMP.  Then below there, we find:
>>
>>     default "4096" if MAXSMP
> 
> Hah, weird.
> I can see now it is possible to parse the MAXSMP help this way, but it
> was not obvious.

Ambiguity is fairly easy.  :(

> In menuconfig you see two questions:
> 
> [ ] Configure Maximum number of SMP Processors and NUMA Nodes
> [8] Maximum number of CPUs
> 
> and setting the first one YES makes the second one go away.
> 
> Perhaps restating the help as "Set number of SMP processors and NUMA
> nodes to the maximum that the kernel supports" might help.

Yes, that sounds better.  Want to submit a patch for that?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
