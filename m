Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0KIB2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:28:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0KIB2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:28:32 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 00/23] netoops support
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Date: Tue, 09 Nov 2010 02:28:26 +0100
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com> (Mike
	Waychison's message of "Mon, 08 Nov 2010 12:31:36 -0800")
Message-ID: <87k4knqo91.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Waychison <mikew@google.com> writes:

I'm still not fully convinced this needs to be a fully separate
mechanism from netconsole.  It seems a lot of work to implement
basically log level.

Maybe netconsole could be patched to support only dumping KERN_EMERG?

But I guess the structured logging has some advantages, although
there have been certainly oops parsers (e.g. kerneloops.org) without it.

>    * I am _NOT_ happy with the remaining userland ABIs presented in this
>      patchset.  Specifically the files "net_dump_now",
>      "net_dump_one_shot", "netdump_fw_version", "netdump_board_name"
>      and

fw_version and board_name is known by the kernel anyways through the DMI
interface, assuming the BIOS supplies that.  We also dump it already
on a standard oops. So why not just use that directly?

As a general user ABI perhaps simply an unstructured string is better
that is included in the packet.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
