Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2IDSL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47583 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab2IDSL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:11:27 -0400
Message-ID: <5046442E.7020207@zytor.com>
Date: Tue, 04 Sep 2012 11:10:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix ACPI BGRT support for images located in EFI boot
 services memory
References: <cover.1346361959.git.josh@joshtriplett.org> <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com> <20120904175952.GA4103@jtriplet-mobl1>
In-Reply-To: <20120904175952.GA4103@jtriplet-mobl1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 10:59 AM, Josh Triplett wrote:
>
> Unfortunately not.  We need enough of ACPI available to go read the
> BGRT to know what to copy, so we need to defer freeing boot services
> code until after we initialize ACPI (and thus everything ACPI needs,
> which includes EFI since ACPI looks for root tables there).
>
>> I wouldn't be surprised if some implementations got really cranky if
>> we accessed boot services data after we installed a new virtual memory
>> map.
>
> Note that I've carefully accessed the boot services data *through* the
> new virtual memory map, which should work fine.
>

There are some platforms which have bugs in this area, so there are 
other reasons to defer freeing up boot memory until as late in the boot 
process as we can possibly get away with.

free_initmem() is presuambly the place that makes most sense.  This is 
EFI-specific but not x86-specific, let's not commingle those concepts, 
please...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

