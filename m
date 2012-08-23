Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab2HWVYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:24:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab2HWVYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:24:06 -0400
Message-ID: <50369F67.8040101@zytor.com>
Date: Thu, 23 Aug 2012 14:23:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com> <1344983957-4996-4-git-send-email-jacob.shin@amd.com> <50356BA9.5030906@zytor.com> <20120823145043.GA4671@jshin-Toonie> <50364E9E.6020104@zytor.com> <20120823201224.GA24203@phenom.dumpdata.com>
In-Reply-To: <20120823201224.GA24203@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 01:12 PM, Konrad Rzeszutek Wilk wrote:
>>
>> Okay... I think I need to grok that a bit better.  For memory
>> allocations, we probably should just use brk allocations, for
>> virtual space allocations it is called the fixmap for a reason (even
>> though the Xen people managed to break that on 32 bits, sigh!)
> 
> Can you rope me in on that? Was that added ooh years ago ?

Yeah, it dates back to the original paravirt work.

The issue is that Xen likes to live at the top of the virtual address
space, which is where the fixmap lives.  Suddenly the fixmap is no
longer at a fixed address, which was sort of the whole idea.

The problem is that on i386 there are very few unmovable boundaries left
in the virtual address space.  The only other one left, really, is at
the very beginning of kernel space.

At this point people's appetite for large changes on 32 bits is limited,
of course.

	-hpa


