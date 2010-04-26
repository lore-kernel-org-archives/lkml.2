Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0DZVpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:45:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0DZVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:45:34 -0400
Message-ID: <2b9433aea407fa99bfc3fba10cc6fb8e.squirrel@www.zytor.com>
In-Reply-To: <20100426142546.2e77b1ba@virtuousgeek.org>
References: <4BC4E55B.7000103@oracle.com>
    <20100426183436.GV11130@hexapodia.org>
    <20100426123135.5d095d2f@virtuousgeek.org>
    <201004261427.57229.bjorn.helgaas@hp.com>
    <20100426133757.3e1d0a75@virtuousgeek.org>
    <a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
    <20100426142546.2e77b1ba@virtuousgeek.org>
Date: Mon, 26 Apr 2010 14:44:50 -0700
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below  
 BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
User-Agent: SquirrelMail/1.4.20-1.fc11
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Mon, 26 Apr 2010 14:44:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Agreed.  The trickier part is handling any platform devices that
> request_resource against that space.  But maybe we don't need to do
> anything special; just making sure we avoid it in the PCI "BIOS" code
> as Bjorn did may be sufficient.
>

Why is that hard?  If a platform device does a request_resource against
that space, it's a request for specific address space and it should be
granted.

        -hpa

