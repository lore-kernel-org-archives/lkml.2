Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0F2Pi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:38:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57068 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab0F2Pi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:38:57 -0400
Message-ID: <4C2A1387.1090406@austin.ibm.com>
Date: Tue, 29 Jun 2010 10:38:47 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Greg KH <gregkh@suse.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
References: <20100628154455.GA13918@suse.de> <1277769867.8354.531.camel@nimitz> <20100629115232.38BC.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100629115232.38BC.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 09:56 PM, KOSAKI Motohiro wrote:
>> On Mon, 2010-06-28 at 08:44 -0700, Greg KH wrote:
>>>> The directories being created are the standard directories, one for each of the memory
>>>> sections present at boot.  I think the most used files in each of these directories
>>>> is the state and removable file used to do memory hotplug.
>>>
>>> And perhaps we shouldn't really be creating so many directories?  Why
>>> not work with the memory hotplug developers to change their interface to
>>> not abuse sysfs in such a manner? 
>>
>> Heh, it wasn't abuse until we got this much memory.  But, I think this
>> one is pretty much 100% my fault.
>>
>> Nathan, I think the right fix here is probably to untie sysfs from the
>> sections a bit.  We should be able to have sysfs dirs that represent
>> more than one contiguous SECTION_SIZE area of memory.
> 
> Why do we need abi breakage? Yourself talked about we guess ppc don't
> actually need 16MB section. I think IBM folks have to confirm it.
> If our guessing is correct, the firmware fixing is only necessary.

Yes, ppc still needs to support add/remove of 16MB sections.  This correlates
to the smallest lmb size on ppc that we need to support.

> 
> Thats said, I don't 100% refuse your idea. it's interesting. but, 
> In generical I hate _unncessary_ abi change.

Me too, but I'm not sure the current sysfs layout of memory scales well
for machines with huge amounts of memory.

How about providing an alternate sysfs layout for systems that have a large
number of memory sections?  Even on the machines I worked with that have
1 and 2 TB of memory, if we increase the memory sections size to equal the
lmb size we still would be creating 6k+ directories for a 1 TB machine.
This would alleviate much of the perfomrance issue but still leaves us with 
a directory of thousands (or tens of thousands for really big systems) 
of memoryXXX subdirectories, which is not really human readable.

Or some method of having a single memory XXX dir represent multiple sections,
as Dave suggested would work. Perhaps there is a way to subdivide the
memory section dirs into separate dirs based on their node.

At the point of dealing with this many memory sections would it make sense
to not create directories for each of the memory sections? Perhaps just
files to report information about the memory sections.

-Nathan

