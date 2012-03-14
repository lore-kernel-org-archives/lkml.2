Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442Ab2CNTfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2CNTfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:35:04 -0400
Message-ID: <4F60F2E4.7060707@redhat.com>
Date: Wed, 14 Mar 2012 16:35:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com>
In-Reply-To: <20120313233217.GB31106@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-03-2012 20:32, Greg KH escreveu:
> On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
>> Prepare the internal structures to represent the memory properties per dimm, 
>> instead of per csrow. 
>>
>> This is needed for modern controllers with more than 2 channels, as the memories 
>> at the same slot number but on different channels (or channel pairs) may be 
>> different.
>>
>> Mauro Carvalho Chehab (6):
>>   edac: Create a dimm struct and move the labels into it
>>   edac: Add per dimm's sysfs nodes
> 
> You need Documentation/ABI entries for these new sysfs files.

Sure. I'll provide it on the final patchset.

Boris suggested some alternatives for the error counter sysfs nodes, but the 
discussion ended by diverging into an implementation detail of hiding the UE
error nodes, without any consensus about the sysfs structure for it.

At the current patchset, the error counter nodes are all under
	sys/devices/system/edac/mc/mc?/

He thinks that a multi-layer struct should be created inside that directory
(it could have 2 or 3 levels of directories, depending on how the memory is
organized at the memory controller), instead of having a large number of files
there.

Anyway, before adding unnedded complexity, I'd like to hear more comments from 
the others before writing a complex patch to create such structure.

So, maybe I could just add what it was there as ABI/testing, and give more
time for kernel and userspace developers to work with it and provide us a better
feedback.

Thanks,
Mauro
