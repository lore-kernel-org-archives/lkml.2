Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690Ab1LPB0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:26:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1LPB0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:26:14 -0500
Message-ID: <4EEA9E1E.9080308@zytor.com>
Date: Thu, 15 Dec 2011 17:25:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        davej@redhat.com, axboe@kernel.dk, herbert@gondor.hengli.com.au,
        ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-2-git-send-email-andi@firstfloor.org> <20111208103540.4778b896@endymion.delvare> <20111208144516.GE24062@one.firstfloor.org> <20111209211601.08dabc88@endymion.delvare>
In-Reply-To: <20111209211601.08dabc88@endymion.delvare>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 12:16 PM, Jean Delvare wrote:
> 
> Irrelevant. You load a driver when any, not all, of the devices in the
> system are supported by said driver. This obviously holds for PCI
> devices and drivers (you don't refrain from loading the network card's
> driver because that driver doesn't support your graphics card), the CPU
> device case is no different (in theory at least.)
> 

Well, it is, actually.  We do a whole lot of tests using boot_cpu_has(),
which really isn't about the boot CPU at all but rather is the
intersection of all features supported by all the CPUs in the system.

There are, however, a handful of drivers which want to be loaded for
"any matching CPU" as opposed to "all matching CPUs" and I guess it
would be useful to have that capability as an alternative.

	-hpa
