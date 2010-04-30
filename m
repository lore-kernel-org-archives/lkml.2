Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab0D3T24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:28:56 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39829 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436Ab0D3Qrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:47 -0400
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <084f72bf-21fd-4721-8844-9d10cccef316@default>
References: <4BD16D09.2030803@redhat.com> >
	 <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> >
	 <4BD1A74A.2050003@redhat.com> >
	 <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> >
	 <4BD1B427.9010905@redhat.com> <4BD1B626.7020702@redhat.com> >
	 <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default> >
	 <4BD3377E.6010303@redhat.com> >
	 <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default4BD43033.7090706@redhat.com> >
	 <ce808441-fae6-4a33-8335-f7702740097a@default> >
	 <20100428055538.GA1730@ucw.cz>
	 <1272591924.23895.807.camel@nimitz 4BDA8324.7090409@redhat.com>
	 <084f72bf-21fd-4721-8844-9d10cccef316@default>
Content-Type: text/plain
Date: Fri, 30 Apr 2010 09:08:00 -0700
Message-Id: <1272643680.23895.2537.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-30 at 08:59 -0700, Dan Magenheimer wrote:
> Dave or others can correct me if I am wrong, but I think CMM2 also
> handles dirty pages that must be retained by the hypervisor.  The
> difference between CMM2 (for dirty pages) and frontswap is that
> CMM2 sets hints that can be handled asynchronously while frontswap
> provides explicit hooks that synchronously succeed/fail.

Once pages were dirtied (or I guess just slightly before), they became
volatile, and I don't think the hypervisor could do anything with them.
It could still swap them out like usual, but none of the CMM-specific
optimizations could be performed.

CC'ing Martin since he's the expert. :)

-- Dave

