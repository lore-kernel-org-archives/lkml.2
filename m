Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0HQPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:52:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0HQPwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:52:36 -0400
Message-ID: <4C6AB00D.8020901@zytor.com>
Date: Tue, 17 Aug 2010 08:51:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: ykzhao <yakui.zhao@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
References: <20100722152220.GA18290@sgi.com>	 <1279849573.13929.28.camel@localhost.localdomain>	 <20100723072301.GC23461@elte.hu> <1279895165.13929.61.camel@localhost.localdomain>
In-Reply-To: <1279895165.13929.61.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 07:26 AM, ykzhao wrote:
>
> Yes. We can't map the corresponding ACPI region as cached under the
> following case:
>      >No E820_ACPI region is reported by BIOS. In such case the ACPI
> table resides in the NVS region
>

Why could we not map the NVS region as cached?  That doesn't seem to 
make sense.  In practice, at least, on all BIOSes I've seen the NVS 
region is just another hunk of RAM.

Sample from a real system:

  BIOS-e820: 000000007d6b0000 - 000000007d6cc000 (ACPI data)
  BIOS-e820: 000000007d6cc000 - 000000007d700000 (ACPI NVS)

Both are clearly RAM.

If you're not talking about the e820 NVS region, that might be a 
different thing, but for the ROM region in the legacy area, the fixed 
MTRRs are often set up to allow caching, and we should be able to map 
them cacheable, e.g. on this system:

   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-CFFFF write-protect
   D0000-DFFFF uncachable
   E0000-FFFFF write-protect

Clearly cacheable.

	-hpa
