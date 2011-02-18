Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1BRRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:42:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:60474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1BRRmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:42:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,188,1297065600"; 
   d="scan'208";a="888976917"
Message-ID: <4D5EAF76.6080301@linux.intel.com>
Date: Fri, 18 Feb 2011 09:42:14 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sfr@canb.auug.org.au, tglx@linutronix.de,
        rjw@sisk.pl
Subject: Re: [tip:x86/trampoline] x86, reboot: Move the real-mode reboot code
 to an assembly file
References: <4D5DFBE4.7090104@intel.com>	<tip-3d35ac346e981162eeba391e496faceed4753e7b@git.kernel.org> <AANLkTikxqk=HEw9R-Du=v-1ti1HDGAY9vaNUep2XARaz@mail.gmail.com>
In-Reply-To: <AANLkTikxqk=HEw9R-Du=v-1ti1HDGAY9vaNUep2XARaz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 04:31 AM, Brian Gerst wrote:
>> +
>> +       /* Patch post-real-mode segment jump */
>> +       movw    dispatch_table(%ebx,%ecx,2),%cx
>> +       movw    %cx, 101f(%ebx)
>> +       movw    %ax, 102f(%ebx)
> 
> This looks wrong.  The type parameter is in %eax, not %ecx, and this
> code is expecting %eax to be a segment.
> 

You're quite right.  I decided to make a change, changed all the
invocations, and forgot to change the actual code.  D'oh!

	-hpa
