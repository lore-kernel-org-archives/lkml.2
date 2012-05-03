Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2ECGkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:40:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2ECGkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:40:16 -0400
Message-ID: <4FA22844.2070204@zytor.com>
Date: Wed, 02 May 2012 23:40:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nick Piggin <npiggin@gmail.com>, Jana Saout <jana@saout.de>,
        Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com> <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com> <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com> <4FA227FB.7060709@zytor.com>
In-Reply-To: <4FA227FB.7060709@zytor.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 11:38 PM, H. Peter Anvin wrote:
> On 05/02/2012 10:57 PM, Linus Torvalds wrote:
>>
>> There are multiple ways to fix this, including just marking that
>> unaligned word access as being able to take an exception, but I had
>> hoped to avoid having to do that. There are alternatives, like always
>> padding allocations up by 7 bytes, but those are nasty too. So I'd
>> like to understand what triggers this for Jana, it's possible we can
>> just work around that particular issue.
>>
> 
> Can we do the trick of aligning the pointer and ignoring the start?
> That would allow even architectures that don't have unaligned accesses
> to work, too.
> 
>> Apr 30 14:02:46 web5 kernel: RIP: e030:[<ffffffff8113c29b>]
> [<ffffffff8113c29b>] link_path_walk+0xab/0x890
>> Apr 30 14:02:46 web5 kernel: RSP: e02b:ffff88001e7a3bc8  EFLAGS: 00010257
>> Apr 30 14:02:46 web5 kernel: CS:  e033
> 
> These segment values look odd in the extreme...
> 
>> Apr 30 14:02:46 web5 kernel:  [<ffffffff810056c9>] ?
> __raw_callee_save_xen_pmd_val+0x11/0x1e
> 
> ... because he's running under Xen-PV.  So his memory map can be
> arbitrarily screwed seven ways to Sunday.
> 

This almost makes me want to suggest adding a taint flag for PV.

	-hpa


