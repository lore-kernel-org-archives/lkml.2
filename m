Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0EaQhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:37:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41587 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0EaQhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:37:20 -0400
Message-ID: <4C03E599.207@zytor.com>
Date: Mon, 31 May 2010 09:36:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <4BFFF517.6040401@sgi.com> <4BFFF6B8.30005@zytor.com> <4BFFF8F8.1070502@sgi.com> <4C0021DC.60608@zytor.com> <4C039980.3020608@sgi.com>
In-Reply-To: <4C039980.3020608@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 04:12 AM, Mike Travis wrote:
> 
> BIOS still assigns the MMIO BAR's so the devices are alive.

OK, so it sounds like the *real* problem is our behavior on address
space exhaustion: it is rather common that a driver will only use one
BAR/address space, and sometimes can even choose which address space to
use.  The right thing would be to defer error until a particular BAR is
requested by the device driver, but I'm not sure if our interfaces
permits that (and I'm on my way to the airport right now so I can't
check...)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

