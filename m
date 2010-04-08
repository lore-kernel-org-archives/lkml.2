Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0DHFDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37288 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0DHFDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:03:17 -0400
Message-ID: <4BBD6306.9010608@zytor.com>
Date: Wed, 07 Apr 2010 22:00:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Yinghai <yinghai.lu@oracle.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio> <4BBD0B0A.3090702@oracle.com> <4BBD18B0.6010302@zytor.com> <20100408001935.GM29192@hexapodia.org>
In-Reply-To: <20100408001935.GM29192@hexapodia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 05:19 PM, Andy Isaacson wrote:
> On Wed, Apr 07, 2010 at 04:43:44PM -0700, H. Peter Anvin wrote:
>>> or you can add
>>> boot_params.screen_info.orig_video_isVGA == 1
>>> or double check scan pci tree to see if video is there or not
>>
>> Perhaps boot_params.screen_info.orig_video_isVGA != 1 because he's not
>> booting in a text mode?
> 
> It's a pretty standard grub2 install (Debian unstable,
> 1.98~20100128-1.2) with something approaching the default config.  Grub
> does seem to put the console in some annoying framebuffer format to draw
> the boot menu, but IIRC it switches back to VGA textmode before booting
> the kernel.

Grub2 gratuitously bypasses the 16-bit initialization code in the Linux
kernel, that could easily be a source of bugs (and with Grub's track
record, probably is.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

