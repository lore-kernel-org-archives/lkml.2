Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2EKGU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:20:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29760 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2EKGUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:20:55 -0400
Date: Fri, 11 May 2012 09:23:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thiago Rafael Becker <trbecker@trbecker.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        jan.kiszka@siemens.com, dhowells@redhat.com
Subject: Re: [PATCH] kgbd: clear compilation warning
Message-ID: <20120511062355.GX22134@mwanda>
References: <1336709620-19351-1-git-send-email-trbecker@trbecker.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336709620-19351-1-git-send-email-trbecker@trbecker.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 01:13:40AM -0300, Thiago Rafael Becker wrote:
> In the function kgbd_arch_set_breakpoint, the variable is only used
> if DEBUG_RODATA is configured. This clears the following compilation
> warning:
> 
> arch/x86/kernel/kgdb.c:749:7: warning: unused variable 'opc'
> 

This doesn't work.  Now there is a "warning: mixing declarations and
code" warning message for people who have CONFIG_DEBUG_RODATA
turned on.

I sent one of these yesterday where I did:

	if (!config_enabled(CONFIG_DEBUG_RODATA))
		return err;

But test it both ways and do a make arch/x86/kernel/kgdb.i and
make sure the code looks ok.

regards,
dan carpenter

