Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0J0RyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:54:09 -0400
Received: from claw.goop.org ([74.207.240.146]:45465 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0J0RyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:54:06 -0400
Message-ID: <4CC8673C.6060706@goop.org>
Date: Wed, 27 Oct 2010 10:54:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <20101027174417.GA19194@a1.tnic>
In-Reply-To: <20101027174417.GA19194@a1.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/27/2010 10:44 AM, Borislav Petkov wrote:
> On Wed, Oct 27, 2010 at 10:31:37AM -0700, Jeremy Fitzhardinge wrote:
>>> Xen shouldn't have any users of this, since it's used for low-level
>>> operations like SMP bootstrap, suspend to RAM, reboot and low-level
>>> BIOS functionality.
>>>
>> Right, but it is being called smack in the middle of setup_arch().  It
>> looks like they could be hidden away in
>> native_pagetable_setup_start/done though.
> I think I can put the second sync-back clone_pgd_range in
> native_pagetable_setup_done but the first one needs to take place right
> at the beginning of setup_arch() because a lot of code in-between relies
> on swapper_pg_dir containing proper entries.

OK.

> Just to make sure I understand you correctly: best it would be for xen
> to not have the copy_pgd_range() calls in setup_arch, correct?

Right.  Could you put the first copy into swapper_pg_dir earlier, before
setup_arch() somewhere that's specific to booting via head_32.S?

    J
