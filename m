Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1E0RDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:03:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46527 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1E0RDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:03:38 -0400
Message-ID: <4DDFD958.9090700@zytor.com>
Date: Fri, 27 May 2011 10:03:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, asm: Clean up desc.h a bit
References: <tip-incpt6y26yd8586idx65t9ll@git.kernel.org>
In-Reply-To: <tip-incpt6y26yd8586idx65t9ll@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 01:39 AM, tip-bot for Ingo Molnar wrote:
> Commit-ID:  9a3865b185e77d1a4ca2d8356e37c19b78168961
> Gitweb:     http://git.kernel.org/tip/9a3865b185e77d1a4ca2d8356e37c19b78168961
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 27 May 2011 09:29:32 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 27 May 2011 09:30:50 +0200
> 
> x86, asm: Clean up desc.h a bit
> 
> I have looked at this file and found it rather ugly - improve
> readability a bit. No change in functionality.
> 

It sure is, but let me also register for the record that I hate the
bloody bitfield.  A lot of what the bitfield does is completely
pointless (breaking down the type field, which really is nothing other
than a magic constant as far as the kernel is anyway) and generates
insanely bad code.

I honestly think if we used macros like GDT_ENTRY() and perhaps a few
variants we would make the code simpler.

	-hpa
