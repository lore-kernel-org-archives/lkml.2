Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab1JIMVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 08:21:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45303 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1JIMVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 08:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20111007185905.GA29127@kroah.com>
References: <1317943022.1095.25.camel@mop> <20111007185905.GA29127@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 9 Oct 2011 14:20:54 +0200
Message-ID: <CAPXgP13ohtmTOp=pNwpr1Vr0irCd97n0t48k2XNYQ65gunm9+Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_A_Plumber=E2=80=99s_Wish_List_for_Linux?=
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 20:59, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:
>> * CPU modaliases in /sys/devices/system/cpu/cpuX/modalias:

> I need to get off my ass and fix this properly, now that Rafael has done
> all of the hard work for sysdev already.  Thanks for reminding me.
>
>> * export ‘struct device_type fb/fbcon’ of ‘struct class graphics’
>> Userspace wants to easily distinguish ‘fb’ and ‘fbcon’ from each other
>> without the need to match on the device name.
>
> Can't we just export a "type" file for the device for these devices?
> Is it really just that simple?

Yeah, it's just adding a 'struct device_type' with a 'name =
"fb/fccon" and DEVTYPE= will appear as a property at the device. So
much for getting off my ass. :)

>> * module-init-tools: provide a proper libmodprobe.so from
>> module-init-tools:
>> Early boot tools, installers, driver install disks want to access
>> information about available modules to optimize bootup handling.
>
> What information do they want to know?

Resolve the alias database that 'depmod' has created from inside any
process. Udev wants to avoid calling ~60 modprobes per bootup for a
bunch of device types like USB-hubs which will never have driver to be
loaded (optimization). Also the installer and module-update tools
sometimes want to query the list of things to load before running all
the magic asynchronously (less hacks).

In general, the command-line-tool-style of doing complexer system
software does not really fit any more into the way we need to do
things today. We need proper libraries in the background that can be
used by whatever thing needs the information, and the same tools we
have already should just be users of their own libraries. We a strict
separation of policy and mechanics. Other users should be able the use
the 'mechanics' of a tool, without executing any 'policy'.

>> * allow user xattrs to be set on files in the cgroupfs (and maybe
>> procfs?)
>
> This shouldn't be that difficult, right?

It shouldn't. We just need to be careful here what to export, when to
use it, and not to create problems and information leaks for
namespaces, which might re-use some of the mount points.

Kay
