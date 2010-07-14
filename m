Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0GNRRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:17:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52201 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0GNRRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:17:12 -0400
Message-ID: <4C3DF105.1050404@austin.ibm.com>
Date: Wed, 14 Jul 2010 12:16:53 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
References: <4C3B3446.5090302@austin.ibm.com>	 <4C3B3895.3040209@austin.ibm.com>	 <20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>	 <4C3C8B9E.7000208@austin.ibm.com>	 <20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com> <1279078016.10995.58.camel@nimitz>
In-Reply-To: <1279078016.10995.58.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 10:26 PM, Dave Hansen wrote:
> On Wed, 2010-07-14 at 09:35 +0900, KAMEZAWA Hiroyuki wrote:
>>   2. I'd like to write a configfs module for handling memory hotplug even when
>>      sysfs directroy is not created.
>>      Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
>>      
>>      When offlining section X.
>>      # insmod configfs_memory.ko
>>      # mount -t configfs none /configfs
>>      # mkdir /configfs/memoryX
>>      # echo offline > /configfs/memoryX/state
>>      # rmdir /configfs/memoryX
>>
>>   And making this operation as the default bahavior for all arch's memory hotplug may
>>   be better...
>>
>> Dave, how do you think ? Because ppc guys uses "probe" interface already,
>> this can be handled... no ?
> 
> I think creating a interface to duplicate the existing sysfs one is a
> bad idea.  I also think removing the existing sysfs one isn't feasible
> since there are users, and it's truly part of the ABI.  So, I'm not
> really a fan on the configfs interface. :(
> 
> I really do think the sysfs interface is fixable.  We should at least
> give it a good shot before largely duplicating its functionality.

I agree with Dave, I don't think another memory hotplug interface is needed.

I am working to update the patchset to remove the split functionality and
fix other items commented on.  this new patch will just split the memory_block
structure so that a memory_block can span multiple memory sections.

Kame, I understand that offlining 16 MB is easier than 256 MB.  From the ppc
perspective though, we are still offlining 256 MB.  We do memory add/remove
on LMB size chunks, so we have to add/remove all of the memory sections contained
in an LMB.  If any one memory section covered by a LMB fails to add/remove, we
restore the memory sections to their orignal state an fail the add/remove operation.
NOTE: the code doing this is not in the kernel, but in the user-space drmgr
command (from powerpc-utils package).

-Nathan 

