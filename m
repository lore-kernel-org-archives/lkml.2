Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2IFGue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:50:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34987 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2IFGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:50:32 -0400
Message-ID: <5048473F.9070704@linux.vnet.ibm.com>
Date: Thu, 06 Sep 2012 12:18:31 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, bp@amd64.org
CC: andi@firstfloor.org, gong.chen@linux.intel.com, ananth@in.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, gregkh@suse.de,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/mce: Pack boolean MCE flags into a structure
References: <20120905102049.9423.6413.stgit@localhost.localdomain> <20120905102201.9423.46671.stgit@localhost.localdomain> <CA+8MBb+T6H1jK624qkPPmK8BJ0T1-FcRM+9JPKubq65wKvfueA@mail.gmail.com>
In-Reply-To: <CA+8MBb+T6H1jK624qkPPmK8BJ0T1-FcRM+9JPKubq65wKvfueA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12090606-3568-0000-0000-0000026CD8B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 12:26 AM, Tony Luck wrote:
> On Wed, Sep 5, 2012 at 3:22 AM, Naveen N. Rao
> <naveen.n.rao@linux.vnet.ibm.com> wrote:
>> Many MCE flags are boolean in nature, but are declared as integers
>> currently. We can pack these into a bitfield to save some space.
>
> Before this patch:
> size arch/x86/kernel/cpu/mcheck/mce.o
>     text	   data	    bss	    dec	    hex	filename
>    18946	   4930	    776	  24652	   604c	arch/x86/kernel/cpu/mcheck/mce.o
>
> After:
> size arch/x86/kernel/cpu/mcheck/mce.o
>     text	   data	    bss	    dec	    hex	filename
>    19335	   4890	    776	  25001	   61a9	arch/x86/kernel/cpu/mcheck/mce.o
>
> So we do indeed see "data" reduced by 40 bytes. But
> "text" is up by 389.  This seems to be because you have
> another change, not described in the commit log, buried
> in part 2 to add get_dont_log_ce(), set_dont_log_ce() etc.
>
> Compiler version: gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC)
>
> I know I'm contradicting the feedback you got from Borislav here, but
> is this code churn really worth it to save 40 bytes? I don't think so.

Hmm.. I think I agree. I don't see a good way to get rid of the 
individual getters and setters without adding some more code churn. I 
guess using boolean would be better. Boris?


Thanks,
Naveen

