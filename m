Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2KPMWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:22:15 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51795 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2KPMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:22:14 -0500
X-AuditID: b753bd60-977e6ba000004744-2c-50a62ff33eaa
X-AuditID: b753bd60-977e6ba000004744-2c-50a62ff33eaa
Message-ID: <50A62FEB.1000002@hitachi.com>
Date: Fri, 16 Nov 2012 21:22:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] uprobes tracer: Add support for @ADDR, @stackN, dereference,
 bitfield arguments
References: <1352877222-23797-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1352877222-23797-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hyeoncheol,

Thank you for working on uprobe enhancement!

First of all, I've failed to apply this on the latest tip tree
because of conflict with below patch.

http://marc.info/?l=linux-kernel&m=134869014622386

(2012/11/14 16:13), Hyeoncheol Lee wrote:
> Add support for @ADDR, @stackN, dereference, bitfield arguments. Uprobes
> tracer supported only register argument. @SYMBOL, $retval, $stack are not
> supported. because a symbol address and whether function starts at a given
> address can't be known.

I see why the @SYMBOL is not supported, but I can't understand the
reason why $retval and $stack aren't supported. At least we can
support $stack, isn't it?

> Uprobes tracer and kprobes tracer have their own fetch type information
> tables and fetch type functions. But they share printing type functions
> and some fetch type functions for register, dereference, and bitfield.
> The common functions are defined in trace_probe.c.

By the way, for easy to review and debug, please separate this
into several patches. This seems to do (1) moving some interfaces
out from trace_probe.c, (2) add fetch_size/fetch members into
recursive fetch function data, (3) introduce userspace memory
fetching functions, and some cleanups.
So, could you split those parts? unless, it is hard to maintain
the source code.

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


