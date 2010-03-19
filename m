Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0CSPB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:01:57 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57892 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751062Ab0CSPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:01:56 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Luis Correia <buga@loide.net>
Subject: Re: [rt2x00-users] rt2500usb broken since 2.6.29
Date: Fri, 19 Mar 2010 16:01:47 +0100
User-Agent: KMail/1.9.10
Cc: users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org
References: <201003182246.54889.linux@rainbow-software.org> <201003182304.43196.linux@rainbow-software.org> <880c1631003181510k1850de40r823418a0b921ecee@mail.gmail.com>
In-Reply-To: <880c1631003181510k1850de40r823418a0b921ecee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003191601.48405.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 March 2010, Luis Correia wrote:
> Hi,
>
> On Thu, Mar 18, 2010 at 22:04, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Thursday 18 March 2010 22:51:18 Luis Correia wrote:
> >> Hi,
> >>
> >> On Thu, Mar 18, 2010 at 21:46, Ondrej Zary
> >
> > <linux@rainbow-software.org>wrote:
> >> > Hello,
> >> > rt2500usb is broken since kernel 2.6.29. It has been discussed before
> >> > but never solved:
> >> > http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> >> > https://bugzilla.redhat.com/show_bug.cgi?id=484888
> >> >
> >> > I have Asus WL-167G and it really does not work. Scanning works,
> >> > association
> >> > too but no packets can be sent (looks like receive works because
> >> > tcpdump shows packets from other machines). DHCP fails (No DHCPOFFERS
> >> > received).
> >> >
> >> > The problem is caused by this patch:
> >> >
> >> > rt2x00: Implement HW encryption (rt2500usb)
> >> >
> >> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=com
> >> >mit ;h=dddfb478b26e29a2b47f655ec219e743b8111015
> >> >
> >> > Removing it from 2.6.29 restores the functionality.
> >> >
> >> > --
> >> > Ondrej Zary
> >>
> >> you can prevent hardware encryption by supplying "nohwcrypt=1" to the
> >> driver.
> >> (modinfo rt2500usb)
> >
> > That did not work. Maybe that was because I just unloaded the rt2500usb
> > module and loaded it again with nohwcrypt=1 without rebooting the
> > machine. Then I removed the HW encryption, recompiled and reloaded and it
> > did not work either. It started to work only after reboot.
>
> did you actually remove the usb module and unloaded the module as well?
>
> you then need to load the module with the option, wait one sec and
> then plug the device back in.
>
> > Does the HW encryption really work with any rt2500usb hardware? How can I
> > help to fix it? Or maybe it should be disabled by default.
>
> I think the HW encription did work in the past, but I'm unsure of the
> proper timeline.

HW encryption was added in 2.6.29 and it does not work there. In 2.6.30, the 
driver is broken even more - it does not work even with HW encryption 
disabled. I'm going to bisect it.

-- 
Ondrej Zary
