Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2COCWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2COCW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:22:28 -0400
Message-ID: <4F61525D.2080404@redhat.com>
Date: Wed, 14 Mar 2012 23:22:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com> <4F611991.9040604@redhat.com> <20120314233225.GA16564@kroah.com>
In-Reply-To: <20120314233225.GA16564@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 14-03-2012 20:32, Greg KH escreveu:
> On Wed, Mar 14, 2012 at 07:20:01PM -0300, Mauro Carvalho Chehab wrote:
>>> Easy rule to remember, never mix "raw" kobjects and 'struct device',
>>> which is what you would be doing here, right?  We can handle many
>>> hundreds of thousands of files and devices in a single directory, no
>>> problem.
>>
>> No. They're all generated with raw kobjects, using kobject_init_and_add() or
>> sysfs_create_file() calls.
> 
> Ick, no.
> 
> Please, never use "raw" kobjects.  Why doesn't 'struct device' work for
> you properly here?  You just messed userspace all up in that it can not
> properly account for the parts of sysfs here in the device tree.
> 
> Anything below /sys/devices/ should be using 'struct device' unless
> there is a _very_ good reason not to.

The raw kobjects logic is there since the beginning of the edac. I've no
idea why.

I remember a few years ago I tried to create a virtual class in order to
create the EDAC devices, in order to use struct devices, but the sysfs
nodes were created outside /sys/devices/system, breaking the ABI.

Not sure what changed on sysfs since then, but, on the time I looked
on it, I was unable to find an easy way to solve it.

So, I gave up and just kept it as-is.

> 
> thanks,
> 
> greg k-h

