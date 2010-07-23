Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0GWRg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:36:59 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59230 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755962Ab0GWRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:36:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Pn85G3uj0iy5PHfqSxtx8pHyONxXCpGuL14+ioeMw4pSlJtTYauWw4IwrRRomF9I2kFRL/r3tYMWnRlydI427cESzGCv+fCU8PWP7q12URgcphCKVAgQ0d7ZZkSrANDi;
Date: Fri, 23 Jul 2010 10:37:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, "" <lists@clanduggan.org>
Subject: Re: [Bug #16388] i915 drm BUG: unable to handle kernel paging
 request at a5e89046
Message-ID: <20100723103712.5b99e8ce@virtuousgeek.org>
In-Reply-To: <PRbv8sgxY6G.A.tAF.rUYSMB@chimera>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	<PRbv8sgxY6G.A.tAF.rUYSMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:15:55 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16388
> Subject		: i915 drm BUG: unable to handle kernel paging request at a5e89046
> Submitter	:  <lists@clanduggan.org>
> Date		: 2010-07-14 16:59 (10 days old)

Looks like some potential memory corruption?  At resume we try to get
connector info but panic due to a bad pointer, maybe in one of the
lists.  Can you gdb your drm_kms_helper module and do "list
*drm_mode_getconnector+0x295" to see what line this is?

Also, what chipset do you have?  Maybe I can reproduce it here with
your kernel config.

-- 
Jesse Barnes, Intel Open Source Technology Center
