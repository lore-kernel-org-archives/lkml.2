Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1DRTlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:41:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37417 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1DRTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:40:59 -0400
Message-ID: <4DAC93BA.4030108@zytor.com>
Date: Mon, 18 Apr 2011 12:40:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
 by alignment
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com> <4DAC4E7F.1010502@zytor.com> <20110418145653.GI2192@amd.com> <4DAC5E16.1020408@zytor.com> <20110418173655.GA8155@8bytes.org> <4DAC7739.2060100@zytor.com> <20110418190620.GD8155@8bytes.org>
In-Reply-To: <20110418190620.GD8155@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 12:06 PM, Joerg Roedel wrote:
> On Mon, Apr 18, 2011 at 10:39:05AM -0700, H. Peter Anvin wrote:
>> I'm going to apply your patch as-is, based on the notion that this is a
>> change of mechanism, and a change of policy is a separate thing.
>> However, we should address the shutdown of the GART first, and then we
>> can move the start address to zero (again, two separate patches.)
> 
> Hmm, thinking again about this, setting the lower-bound to 0 may break
> kdump setups. The kdump kernel is then able to allocate an aperture too
> and that may use half of the memory from the kdump-system so that the
> dump-process triggers OOM.
> As it is now, the GART is automatically disabled when the BIOS doesn't
> setup it correctly and the machine has not more than 512MB of memory.
> Either we keep it as is or, with the changes suggested above, we handle
> it like soft-iotlb and don't use gart for dma-api at all when
> max_pfn is smaller than 4G.
> 

OK, kdump is no longer limited to 512 MiB and so that number is spurious
in the context of kdump.  If that is broken it is already broken.  Thus
the 512 MiB number already is looking spurious.

	-hpa
