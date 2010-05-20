Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0ETSiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:38:00 -0400
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:29971 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754020Ab0ETSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:37:58 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 14:37:58 EDT
Message-ID: <4BF58054.8060601@kingswood-consulting.co.uk>
Date: Thu, 20 May 2010 19:32:52 +0100
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: NR_CPUS configuration option wrong
References: <ht3rr8$b5f$2@dough.gmane.org> <20100520103851.8e051a3f.randy.dunlap@oracle.com>
In-Reply-To: <20100520103851.8e051a3f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 20 May 2010 18:34:32 +0100 Frank A. Kingswood wrote:
> 
>> Hi!
>>
>> The configuration MAXSMP help text indicates it is used to enable 
>> configuration of number of CPUs. However, NR_CPUS depends on !MAXSMP.
>>
>> arch/x86/Kconfig:
>> 758 config NR_CPUS
>> 759         int "Maximum number of CPUs" if SMP && !MAXSMP
> 
> That line depends on !MAXSMP.  Then below there, we find:
> 
> 	default "4096" if MAXSMP

Hah, weird.
I can see now it is possible to parse the MAXSMP help this way, but it 
was not obvious.

In menuconfig you see two questions:

[ ] Configure Maximum number of SMP Processors and NUMA Nodes
[8] Maximum number of CPUs

and setting the first one YES makes the second one go away.

Perhaps restating the help as "Set number of SMP processors and NUMA 
nodes to the maximum that the kernel supports" might help.

Thanks,

Frank
