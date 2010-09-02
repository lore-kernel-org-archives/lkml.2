Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0IBRjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:39:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33537 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0IBRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:39:50 -0400
Message-ID: <4C7FE163.4000906@austin.ibm.com>
Date: Thu, 02 Sep 2010 12:39:47 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/8] v5 De-couple sysfs memory directories from memory
 sections
References: <4C60407C.2080608@austin.ibm.com> <20100831215745.GA7641@kryten>
In-Reply-To: <20100831215745.GA7641@kryten>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 04:57 PM, Anton Blanchard wrote:
> 
> Hi Nathan,
> 
>> This set of patches de-couples the idea that there is a single
>> directory in sysfs for each memory section.  The intent of the
>> patches is to reduce the number of sysfs directories created to
>> resolve a boot-time performance issue.  On very large systems
>> boot time are getting very long (as seen on powerpc hardware)
>> due to the enormous number of sysfs directories being created.
>> On a system with 1 TB of memory we create ~63,000 directories.
>> For even larger systems boot times are being measured in hours.
>>
>> This set of patches allows for each directory created in sysfs
>> to cover more than one memory section.  The default behavior for
>> sysfs directory creation is the same, in that each directory
>> represents a single memory section.  A new file 'end_phys_index'
>> in each directory contains the physical_id of the last memory
>> section covered by the directory so that users can easily
>> determine the memory section range of a directory.
> 
> I tested this on a POWER7 with 2TB memory and the boot time improved from
> greater than 6 hours (I gave up), to under 5 minutes. Nice!

Thanks for testing this out.  I was able to test this on a 1 TB system
and saw memory sysfs creation times go from 10 minutes to a few seconds.
It's good to see the difference for a 2 TB system.

-Nathan

