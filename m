Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2GNMfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:35:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37343 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2GNMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <1342239493.25597.461.camel@deadeye.wl.decadent.org.uk>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<1342239493.25597.461.camel@deadeye.wl.decadent.org.uk>
Date: Sat, 14 Jul 2012 08:35:50 -0400
Message-ID: <CA+5PVA4iOvQyBXr3NHd0M+kpnqqCtVjRR+QExe632JLc5NsQJA@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Josh Boyer <jwboyer@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 12:18 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>  - distro/Kconfig:
>>
>>     config DISTRO_REQUIREMENTS
>>         bool "Pick minimal distribution requirements"
>>
>>     choice DISTRO
>>         prompt "Distribution"
>>         depends on DISTRO_REQUIREMENTS
>>
>>     config FEDORA
>>     config OPENSUSE
>>     config UBUNTU
>>     ...
>>
>>     endchoice
>>
>> and then depending on the DISTRO config, we'd include one of the
>> distro-specific ones with lists of supported distro versions and then
>> the random config settings for that version:
>
> You might also want to *un*select some options like
> CONFIG_SYSFS_DEPRECATED and CONFIG_SYSFS_DEPRECATED_V2 that need to be
> set one way or the other depending on the version of udev.  (I think
> it's possible to kluge this with the addition of a hidden negative
> config option.)
>
> How about stuff like NET and INET, that every distro will need and yet
> is configurable even without EXPERT?

Yeah, I'm sure once distro configs are created we'll find quite a bit
similarity in them.  We could create Kconfig.distro that has all the
common options selected and then have the per distro Kconfig files
select that.  Sure we'd need to watch Kconfig.distro (or
Kconfig.min-distro) for changes, but I'd hope the distro maintainers
would sign up to maintain these things upstream and be keeping an eye
on it anyway.

josh
