Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab2EOOg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:36:29 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33213 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab2EOOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:36:25 -0400
Message-ID: <4FB269BF.3090801@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 20:05:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <1336963067.2154.2.camel@shrek.rexursive.com> <1336963613.2154.4.camel@shrek.rexursive.com> <1336964335.2154.5.camel@shrek.rexursive.com> <1336981522.1678.0.camel@shrek.rexursive.com> <1336993890.1662.1.camel@shrek.rexursive.com> <1336996035.1628.2.camel@shrek.rexursive.com> <1337039996.1628.9.camel@shrek.rexursive.com>
In-Reply-To: <1337039996.1628.9.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051505-3568-0000-0000-000001C583DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:29 AM, Bojan Smojver wrote:

> On Mon, 2012-05-14 at 21:47 +1000, Bojan Smojver wrote:
>> No. That hangs my box.
>>
>> This triggers a bug in workqueues code (essentially the same as the
>> previous patch, except for sys_sync() not being done):
> 
> Alan/Srivatsa,
> 
> Coming back to the explanation of how this whole thing works, it would
> seem that at the point of image writing all devices are fully functional
> (not just some, as I mistakenly believed). However, the processes are
> supposed to be already frozen, right? Calling suspend_prepare(), which
> will essentially try to freeze the processes and kernel threads, seems
> like the wrong thing to do.
> 
> Did you guys mean that we should be calling
> pm_notifier_call_chain(PM_SUSPEND_PREPARE) only here?
> 


Exactly! And also arrange for the corresponding PM_POST_SUSPEND notification
to happen at the end of suspend-to-ram stage...

Regards,
Srivatsa S. Bhat

