Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2K2UmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:42:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:21247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2K2UmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:42:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="249420574"
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
	<1354121029-1376-23-git-send-email-koverstreet@google.com>
	<m28v9kgsen.fsf@firstfloor.org> <20121129185720.GE15094@google.com>
	<20121129185953.GW16230@one.firstfloor.org>
	<20121129191214.GG15094@google.com>
	<20121129192003.GX16230@one.firstfloor.org>
	<20121129192925.GH15094@google.com> <20121129193452.GI19042@kvack.org>
	<20121129202231.GJ15094@google.com>
Date: Thu, 29 Nov 2012 12:42:17 -0800
In-Reply-To: <20121129202231.GJ15094@google.com> (Kent Overstreet's message of
	"Thu, 29 Nov 2012 12:22:31 -0800")
Message-ID: <m2fw3sf8eu.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> On Thu, Nov 29, 2012 at 02:34:52PM -0500, Benjamin LaHaise wrote:
>> On Thu, Nov 29, 2012 at 11:29:25AM -0800, Kent Overstreet wrote:
>> > There's some kind of symmetry going on here, and if I'd been awake more
>> > in college I could probably say exactly why it works, but it does.
>> 
>> I think the catch is that using only a 32 bit counter is something the 
>> user could arbitrarily control the sum of all parts.  I think a 64 bit 
>> counter may be required to ensure no overflow occurs.  Otherwise, an 
>> overflow could result in a premature free when there are still 2^32 
>> objects active thanks to a malicious user (possible on systems with lots 
>> of memory these days -- remote, but possible).
>
> That's no different from regular atomic_t - but you're right, we
> should be using size_t for anything userspace can manipulate.

The regular atomic_t is limited in ways that you are not.
See my original mail.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
