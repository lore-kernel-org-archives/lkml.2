Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2DHSPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 14:15:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52977 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2DHSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 14:15:38 -0400
Message-ID: <4F81D5C4.9000503@openvz.org>
Date: Sun, 08 Apr 2012 22:15:32 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com>
In-Reply-To: <4F80892A.7050104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Currently, devpts supports a legacy mode where only one instance exists.
>   For backwards compatibility, this is also the default mode, but the
> right thing should be to migrate everyone over to the "newinstance" scheme.
>
> However, it is increasingly clear that that is not happening; neither
> the distros nor udev support this by default at this point.
>
> I think it might be time we set a sunset date for the legacy mode,
> probably around kernel 3.9 at this point.
>
> The big change is that /dev/ptmx instead of being a device node should
> be a symlink to /dev/pts/ptmx, which is then either chmodded to the
> proper permissions, or given proper permissions via the ptmxmode mount
> options to devpts.  The latter is probably preferable from a technical
> point of view since it doesn't create a "gap".
>
> As such, I would like to suggest the following:
>
> 1. For 3.5, add this to feature-removal.txt.
> 2. For 3.6, remove CONFIG_DEVPTS_MULTIPLE_INSTANCES as a configuration
>     option, and printk a warning if devpts is mounted without the
>     "newinstance" option.
> 3. For 3.9 remove the legacy support including support for a ptmx node
>     outside the devpts filesystem.
>
> 	-hpa
>

I think we should give the way to test compatibility as early as possible, so:
2'. For 3.6 add CONFIG_DEVPTS_LEGACY_INSTANCE =y by default, if it =n:
     always create new instance (ignore "newinstance") and remove "ptmx" from sysfs.
