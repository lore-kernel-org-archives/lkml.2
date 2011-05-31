Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab1EaTIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:08:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56433 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1EaTIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:08:44 -0400
Message-ID: <4DE53C80.3070406@zytor.com>
Date: Tue, 31 May 2011 12:07:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Matthew Garrett <mjg@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        davej@redhat.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        eranian@google.com, penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <1306442367.2279.25.camel@dan>	 <20110531165252.GB8971@srcf.ucam.org> <4DE5360D.5070809@zytor.com>	 <20110531185122.GA11998@srcf.ucam.org> <1306868609.6317.25.camel@dan>
In-Reply-To: <1306868609.6317.25.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 12:03 PM, Dan Rosenberg wrote:
> 
> Just for the record, I've put this patch on hold until there's some more
> consensus about whether boot-time randomization of the physical kernel
> address is the best approach.  There are some other potential issues
> that haven't been brought up yet publicly, such as the possibility of
> local attackers performing cache timing attacks to find the kernel image
> location at runtime, which may make traditional ASLR somewhat pointless
> regardless (except in the case of remote attackers, I suppose).  Perhaps
> HPA's suggestion of further modularizing the kernel would have some
> advantages in this regard.
> 

I'm probably going to implement the whole-image randomization as an
option in the Syslinux bootloader; it is a *lot* easier to do this
correctly in the bootloader.

	-hpa
