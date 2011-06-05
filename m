Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1FENzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1FENzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:55:52 -0400
Message-ID: <4DEB8ADE.6070909@redhat.com>
Date: Sun, 05 Jun 2011 16:55:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [POC] mce: replace TIF_MCE_NOTIFY with TIF_USER_RETURN_NOTIFY
References: <4de043641213294e72@agluck-desktop.sc.intel.com>
In-Reply-To: <4de043641213294e72@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2011 03:35 AM, Luck, Tony wrote:
> [Oops - forgot to Cc: LKML!]
> Ingo wrote:
> >  We already have a generic facility to do such things at
> >  return-to-userspace: _TIF_USER_RETURN_NOTIFY.
>
> This is what it might look like if we replaced the current use
> of TIF_MCE_NOTIFY with TIF_USER_RETURN_NOTIFY in mce.c
>
> Question: the notifier can potentially send signals to the current
> process - so should the check for _TIF_USER_RETURN_NOTIFY in do_notify_resume
> be moved before the check for _TIF_SIGPENDING?

It is unnecessary.  If a signal is raised, then _TIF_SIGPENDING will be 
ORed into the flags, and when we try to return again, we'll notice it 
and go right back into do_notify_resume().

> Would doing do be a problem
> for the existing user of user-return-notifiers (kvm)?

It would not be a problem.  The orders of the checks should be immaterial.

<snip patch>

Looks good.

-- 
error compiling committee.c: too many arguments to function

