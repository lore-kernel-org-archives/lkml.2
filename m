Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0HLFGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:06:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab0HLFGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:06:48 -0400
Message-ID: <4C638140.1080202@zytor.com>
Date: Wed, 11 Aug 2010 22:06:08 -0700
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
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>	<20100811164310.a4790773.randy.dunlap@oracle.com>	<20100811173327.3ae325ff.akpm@linux-foundation.org>	<4C63771B.6030005@zytor.com> <20100811213013.ab501c6e.akpm@linux-foundation.org>
In-Reply-To: <20100811213013.ab501c6e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 09:30 PM, Andrew Morton wrote:
> 
> It occurs so rarely that it's probably not worth bothering about, IMO.
> 

I think the real question is if we want people to convert:

	if (copy_from_user(foo, bar, sizeof *foo))
		return -EFAULT;

... into ...

	if (get_user(*foo, bar))
		return -EFAULT;

... or ...

	rv = get_user(*foo, bar);
	if (rv)
		return rv;

... where *foo is a structure type.  It does have the advantage that a
single API does everything, simple or not, but has the disadvantage that
the partial-access semantics are now less explicit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

