Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2CTSmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:42:18 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44857 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2CTSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:42:17 -0400
Message-ID: <4F68CF7E.8070605@windriver.com>
Date: Tue, 20 Mar 2012 13:42:06 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
References: <4E7A46C0.6010804@am.sony.com>
In-Reply-To: <4E7A46C0.6010804@am.sony.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 03:19 PM, Tim Bird wrote:
> This fixes a bug with setting a breakpoint during kdb initialization
> (from kdb_cmds). Any call to kdb_printf() before the initialization
> of the kgdboc serial console driver (which happens much later during
> bootup than kdb_init), results in kernel panic due to the use of
> dbg_io_ops before it is initialized.

I added this patch to the merge queue for the 3.4 kernel.

In the test and review of this patch, I thought there might be another
race condition with kdb pager, but this is not the case.  The run time
validation shows that the kdb pager can only get activated by entering
and configuring the kdb shell and it is turned off on exit, so we are
all set and no further changes are needed.

Thanks,
Jason.


