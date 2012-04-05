Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2DESho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 14:37:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34726 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2DEShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 14:37:42 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [3.4-rc1][Regression][network wireless] 'task xxxx blocked for more than 120 seconds' after resume
Date: Thu, 5 Apr 2012 20:37:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.7.4; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <201204022157.05598.maciej.rutecki@gmail.com> <1333440469.3574.0.camel@jlt3.sipsolutions.net> <20120405103254.GE2378@redhat.com>
In-Reply-To: <20120405103254.GE2378@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204052037.37497.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 5 kwietnia 2012 o 12:32:54 Stanislaw Gruszka wrote:
> On Tue, Apr 03, 2012 at 10:07:49AM +0200, Johannes Berg wrote:
> > -ilw
> > +netdev
> > 
> > I have no idea what this could be, but I'm almost certain it's not
> > caused by our wireless driver. Looks more like rtl8169 is to blame.
> 
> I'm not sure. Looks like there is deadlock or infinite loop in process
> that holds rtnl lock. This can be wireless driver, wired driver or
> generic network code bug.
> 
> Maciej, please recompile with CONFIG_LOCKDEP and check if it will not
> find any deadlock. If not, when problem will happen please do

Did you mean "CONFIG_LOCKDEP_SUPPORT"?

$ cat /boot/config-3.4.0-rc1 | grep CONFIG_LOCKDEP
CONFIG_LOCKDEP_SUPPORT=y

> 
> echo w > /proc/sysrq-trigger
> dmesg -c > dmesg1.txt

http://mrutecki.pl/download/kernel/3.4-rc1/netdev_resume/dmesg1.txt

> echo t > /proc/sysrq-trigger
> dmesg > dmesg2.txt

http://mrutecki.pl/download/kernel/3.4-rc1/netdev_resume/dmesg2.txt

> 
> and provide those files.
> 
> Additionally there are also lot in dmesg:
> 
>  netlink: 140 bytes leftover after parsing attributes.
> 
> This need to be investigated as well. Perhaps you could modify error
> message, to show what netlink messages/attributes are processed.
> 
> Thanks
> Stanislaw

BTW. From tomorrow till Tuesday I'll be on vacation, so until then I could 
respond to the e-mails.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
