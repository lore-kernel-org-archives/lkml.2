Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab0HLEX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 00:23:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60719 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab0HLEX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 00:23:27 -0400
Message-ID: <4C63771B.6030005@zytor.com>
Date: Wed, 11 Aug 2010 21:22:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        gcosta@redhat.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        ying.huang@intel.com,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: + drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
 added to -mm tree
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>	<20100811164310.a4790773.randy.dunlap@oracle.com> <20100811173327.3ae325ff.akpm@linux-foundation.org>
In-Reply-To: <20100811173327.3ae325ff.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Linux and linux-arch.  The context is that get_user/put_user
don't work on 64 bit values on i386.]

On 08/11/2010 05:33 PM, Andrew Morton wrote:
> 
> Anyway, this should be fixed in x86 core, I suspect.

After looking at it -- and suffering a bad case of déjà vu -- I'm
reluctant to change it, as get/put_user are specified to work only on
locally atomic data:

 * This macro copies a single simple variable from user space to kernel
 * space.  It supports simple types like char and int, but not larger
 * data types like structures or arrays.

Given that u64 is not a simple type on 32 bits, it would appear that the
behavior is intentional.

A user might very well find that supporting u64 and/or structure types
would be beneficial, but it would a) be a semantic change, and b) would
introduce the possibility of a partially completed transfer.  That is a
semantic change to the interface.  However, it may very well be nicer to
have a generally available get_user()/put_user() for the cases which
would just kick an EFAULT up the stack when they fail anyway.

If there is consensus for making get_user/put_user a general interface,
I'm more than willing to do the x86 changes, but I don't want to do them
a) unilaterally and b) for 2.6.36.  This seems like .37 material at this
point.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

