Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0FYMDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:03:40 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51704 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0FYMDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:03:39 -0400
X-AuditID: b753bd60-a8003ba000007d15-d3-4c249b186537
Message-ID: <4C249B16.2090209@hitachi.com>
Date: Fri, 25 Jun 2010 21:03:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: allow cross compiling with DWARF support
References: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com> <4C249027.1060304@hitachi.com> <20100625114150.GE4510@wear.picochip.com>
In-Reply-To: <20100625114150.GE4510@wear.picochip.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Iles wrote:
> On Fri, Jun 25, 2010 at 08:16:55PM +0900, Masami Hiramatsu wrote:
>> Jamie Iles wrote:
>>> The path to elfutils was previously hardcoded as /usr/include/elfutils
>>> which does not work with cross compilers. If CROSS_COMPILE is set, try
>>> to set an include path from GCC's sysroot if GCC was built with sysroot
>>> support, if sysroot support isn't enabled, don't specify a path for
>>> elfutils allowing the user to set it with EXTRA_CFLAGS.
>> Hmm, I'm not so sure about cross compiling. I just thought
>> if there is no sysroot support, we should warn user instead of
>> just failing to find elfutils.
> Is that something that you really need to warn the user about? If they have a
> compiler without sysroot support they can still cross compile using
> EXTRA_CFLAGS and the warning would be needless. There isn't a real requirement
> for sysroot here, just a path to the elfutils headers.

It seems that $ELFUTILS_INCLUDE become "" without sysroot support.
In that case, I guess that user have to set the elfutils header
path to  EXTRA_CFLAGS and, make will just show "No libdw.h found
or old libdw.h found ..." message. (I just guess, not so familier
with cross compile...)

So, I just like to suggest adding a message like as;
"No sysroot support. Please set elfutils include path in EXTRA_CFLAGS."
Doesn't it make easier to find a problem?

Other parts are OK for me.

Thank you,
