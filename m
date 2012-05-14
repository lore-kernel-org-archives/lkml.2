Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab2EOAAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:00:01 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35253 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2ENX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:59:59 -0400
Message-ID: <1337039996.1628.9.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Tue, 15 May 2012 09:59:56 +1000
In-Reply-To: <1336996035.1628.2.camel@shrek.rexursive.com>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <1336963067.2154.2.camel@shrek.rexursive.com>
	 <1336963613.2154.4.camel@shrek.rexursive.com>
	 <1336964335.2154.5.camel@shrek.rexursive.com>
	 <1336981522.1678.0.camel@shrek.rexursive.com>
	 <1336993890.1662.1.camel@shrek.rexursive.com>
	 <1336996035.1628.2.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 21:47 +1000, Bojan Smojver wrote:
> No. That hangs my box.
> 
> This triggers a bug in workqueues code (essentially the same as the
> previous patch, except for sys_sync() not being done):

Alan/Srivatsa,

Coming back to the explanation of how this whole thing works, it would
seem that at the point of image writing all devices are fully functional
(not just some, as I mistakenly believed). However, the processes are
supposed to be already frozen, right? Calling suspend_prepare(), which
will essentially try to freeze the processes and kernel threads, seems
like the wrong thing to do.

Did you guys mean that we should be calling
pm_notifier_call_chain(PM_SUSPEND_PREPARE) only here?

-- 
Bojan

