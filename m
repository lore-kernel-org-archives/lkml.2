Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2JHKJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:09:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44929 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab2JHKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:09:45 -0400
Message-ID: <1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: boot failure on i7-3317u in Samsung 900x3c
From: Matt Fleming <matt@console-pimps.org>
To: Mike Bakhterev <mike.bakhterev@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 08 Oct 2012 11:09:34 +0100
In-Reply-To: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
References: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing some arch and MCE folks since my MCE-foo is weak)

On Mon, 2012-10-08 at 00:43 +0600, Mike Bakhterev wrote:
> Greetings.
> 
> When i'm trying to boot the subject maching in UEFI mode i get
> sometimes machine check exception 0xbe2000000003110a (i was not able
> to decode this, as some bits are not covered in Intel's Manuals). It
> emerges when i am booting 3.4.x, 3.5.4 and 3.5.5 kernels from
> ArchLinux. When i am booting from SSD i get this error all the time,
> when i'm booting from USB stick i get this sometimes (quite frequently
> and the probability to boot succesfully is increased when i specify
> "verbose" kernel option). I'm booting with systemd. The sytems boots
> always successfully, when i use the installation ArchLinux image,
> which is shipped with 3.5 kernel and boots in BIOS mode with
> traditional initscripts.

We've seen things like this before on Samsung laptops,

	https://bugzilla.kernel.org/show_bug.cgi?id=47121

We attributed it to a buggy UEFI implementation.
	
> It looks like race condition when configuring memory or something like this.
> 
> It is not hardware error, because Windows 7 and 8 boot and run fine.
> And this is my second unit, because the first one was broken
> (something with motherboard) when running Windows 8, and Linux on that
> broken machine reported the same MCE. Now Windows works OK (if you
> could say, it works), and Linux reports the same MCEs.

So both Windows 7 and 8 boot successfully on your new laptop, but every
OS failed with the *same* MCE error on your first? That is interesting. 

Does anyone have a clue how to diagnose this further? I still think it's
a buggy UEFI implementation, especially since it ships with a CSM. Is it
possible that these MCE errors are non-fatal on Win 7/8?

-- 
Matt Fleming, Intel Open Source Technology Center

