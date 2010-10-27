Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0J0Rbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:31:41 -0400
Received: from claw.goop.org ([74.207.240.146]:60692 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab0J0Rbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:31:39 -0400
Message-ID: <4CC861F9.8080200@goop.org>
Date: Wed, 27 Oct 2010 10:31:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com>
In-Reply-To: <4CC85EE6.7030608@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/27/2010 10:18 AM, H. Peter Anvin wrote:
> On 10/27/2010 9:50 AM, Jeremy Fitzhardinge wrote:
>>
>> This never used to be a problem.  Perhaps we can change how
>> clone_pgd_range is used at boot time to avoid it in the Xen case (since
>> we don't care about the secondary pagetable)?
>>
>
> Xen shouldn't have any users of this, since it's used for low-level
> operations like SMP bootstrap, suspend to RAM, reboot and low-level
> BIOS functionality.
>

Right, but it is being called smack in the middle of setup_arch().  It
looks like they could be hidden away in
native_pagetable_setup_start/done though.

    J
