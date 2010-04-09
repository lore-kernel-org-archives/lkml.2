Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0DIWpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:45:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0DIWpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:45:45 -0400
Message-ID: <4BBFADDB.6000508@zytor.com>
Date: Fri, 09 Apr 2010 15:44:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org>
In-Reply-To: <20100409223532.GC11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:35 PM, Andy Isaacson wrote:
> [    2.267740] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
> [    2.274701] pci 0000:00:1f.2: BAR 5: set to [mem 0x000a0000-0x000a07ff] (PCI address [0xa0000-0xa07ff]

Looks like this is something the kernel is assigning to it.  It *does*
get marked reserved:

> [    0.000000]   #6 [000009ec00 - 00000f0000]   BIOS reserved

... but that doesn't seem to keep the PCI code from assigning anything
there.  This is a Very Bad thing in general... if we're assigning
devices to areas marked reserved, we have a huge problem.

	-hpa
