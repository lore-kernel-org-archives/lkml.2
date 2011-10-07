Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1JGTPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:15:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35135 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab1JGTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:15:51 -0400
X-Sasl-enc: mr0On9rGqhS1nyY9Yuh0qChz1LMjuj+ax9erl1CIXU9z 1318014950
Date: Fri, 7 Oct 2011 11:59:05 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007185905.GA29127@kroah.com>
References: <1317943022.1095.25.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317943022.1095.25.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:
> * CPU modaliases in /sys/devices/system/cpu/cpuX/modalias:
> useful to allow module auto-loading of e.g. cpufreq drivers and KVM
> modules. Andy Kleen has a patch to create the alias file itself. CPU
> ‘struct sysdev’ needs to be converted to ‘struct device’ and a ‘struct
> bus_type cpu’ needs to be introduced to allow proper CPU coldplug event
> replay at bootup. This is one of the last remaining places where
> automatic hardware-triggered module auto-loading is not available. And
> we’d like to see that fix to make numerous ugly userspace work-arounds
> to achieve the same go away.

I need to get off my ass and fix this properly, now that Rafael has done
all of the hard work for sysdev already.  Thanks for reminding me.

> * export ‘struct device_type fb/fbcon’ of ‘struct class graphics’
> Userspace wants to easily distinguish ‘fb’ and ‘fbcon’ from each other
> without the need to match on the device name.

Can't we just export a "type" file for the device for these devices?
Is it really just that simple?

> * module-init-tools: provide a proper libmodprobe.so from
> module-init-tools:
> Early boot tools, installers, driver install disks want to access
> information about available modules to optimize bootup handling.

What information do they want to know?

> * allow user xattrs to be set on files in the cgroupfs (and maybe
> procfs?)

This shouldn't be that difficult, right?

Thanks for the list, much appreciated.

greg k-h
