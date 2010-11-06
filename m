Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0KFTEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:04:45 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:58139 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0KFTEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:04:44 -0400
Message-ID: <4CD5A6C8.8030603@asbjorn.biz>
Date: Sat, 06 Nov 2010 19:04:40 +0000
From: =?UTF-8?B?QXNiasO4cm4gU2xvdGggVMO4bm5lc2Vu?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Sven-Haegar Koch <haegar@sdinet.de>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: select userland architecture based on
 UTS_MACHINE
References: <4CD406C7.8090801@asbjorn.biz> <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz> <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
In-Reply-To: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 01:42 PM, Sven-Haegar Koch wrote:
> On Fri, 5 Nov 2010, Asbjoern Sloth Toennesen wrote:
> 
>> Instead of creating the debian package for the compiling userland,
>> create it for a userland matching the kernel thats being compiled.
> 
>> Eg. with this patch the following make command:
>>
>> 	make ARCH=i386 deb-pkg
>>
>> will output an i386 Debian package instead of an amd64 one,
>> when run on an amd64 machine.
> 
> How do I either select a differnet package-arch or reverse to the 
> current way?
> 
> I am right now using 'make ARCH=x86_64 deb-pkg' on a 32bit userspace
> environment running with a 64bit kernel, wanting to create packages to 
> be installed in this i386 arch.
>
> (As I want 64bit support where possible (mostly for AES-NI support in 
> dm-crypt), but don't have the time available to do a complete userspace 
> reinstall and reconfiguration)

Sounds like an one off thing, so in your case forcing the installation
should work:

	dpkg --force-architecture linux-image-*.deb

The problem with that approach is that it doesn't work with APT, but I
doubt that there are any private APT repositories with this environment.

The issue with one kernel and 2 userspaces will also arise in sparc,
when the sparc64 userland gets going. So it will need to be dealt with
at some point, so I create a 3 lines additional patch for it.
