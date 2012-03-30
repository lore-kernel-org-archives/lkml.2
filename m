Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab2C3CNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759830Ab2C3CNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:13:12 -0400
Message-ID: <4F7516B3.8070505@redhat.com>
Date: Thu, 29 Mar 2012 23:13:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Greg K H <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com> <1333040821-6253-2-git-send-email-mchehab@redhat.com> <20120329220300.GA16491@kroah.com> <4F74EDEC.5020804@redhat.com> <20120329234037.GA16094@kroah.com>
In-Reply-To: <20120329234037.GA16094@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-03-2012 20:40, Greg K H escreveu:
> On Thu, Mar 29, 2012 at 08:19:08PM -0300, Mauro Carvalho Chehab wrote:
>>> Sweet, as per the documentation in the Documentation/kobjects.txt file,
>>> I get to publically mock you for thinking you are smarter than the
>>> kernel and this is an acceptable way to "outwhit" the driver core from
>>> spitting errors at you when the kobject is released.
>>
>> There's nothing there to free: all EDAC structures are allocated once
>> (see edac_mc_alloc() and edac_align_ptr() logic, at drivers/edac/edac_mc.c).
>>
>> Even the struct device for all csrows/channels/mcu is done on a single alloc
>> there. Trying to free it earlier would cause a segfault.
> 
> That's wrong then, these are multiple struct devices, all with their own
> reference counts, you can't just treat them all as the same thing, even
> if it happens to line up with the module reference count.
> 
>> I didn't wrote that logic, nor I was tempted to change it: as this subsystem 
>> is focused on memory error detection, having every data structure used there
>> on a single page helps to minimize the probability of having an error at the 
>> memory used to store the EDAC data.
> 
> Possibly, but again, you have multiple reference counts, you can't just
> wave them off as being inconvenient.  Please read the documentation for
> more details why.

This is there since the beginning. The current kobj's have this issue. Those
patchsets are not making it better or worse, as the EDAC csrow kobj's are
already there at the current approach: all of them are allocated together
with the mci kobj.

On the other hand, I'm working on this patch series in order to correct a 
serious bug at the EDAC API almost all days during the last 2 months, as
nobody ever cared enough to address this serious issue.

However, every time this patch series is submitted, someone come up with a 
bright idea to ask me to add more work to the scope, delaying its addition 
forever.

While I'm not convinced that moving from a single memory allocation into a 
series of k*alloc is a good thing for a subsystem that is there to detect
memory errors (as having everything altogether into a single page can
reduce the chances of errors at the EDAC data), I can work latter on a 
patchset to fix this issue for EDAC MC, but I'll do it only after merging 
this series, as it is counter-productive to do it otherwise, having to 
repeat the same set of tests on 10 machines (and compile the entire series 
of patches on 8 different archs/sub-archs).

So, I really want to move this ahead. So, please, first things first: let's
first fix the more serious bug. Then, we can fix the other minor stuff
that aren't so far causing any noticeable harm.

Regards,
Mauro


