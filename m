Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1FLIaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:30:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1FLIaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:30:10 -0400
Message-ID: <4DF478F5.6090507@redhat.com>
Date: Sun, 12 Jun 2011 11:29:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
In-Reply-To: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 12:35 AM, Luck, Tony wrote:
> From: Tony Luck<tony.luck@intel.com>
>
> Ingo wrote:
> >  We already have a generic facility to do such things at
> >  return-to-userspace: _TIF_USER_RETURN_NOTIFY.
>
> This just a proof of concept patch ... before this can become
> real the user-return-notifier code would have to be made NMI
> safe (currently it uses hlist_add_head/hlist_del, which would
> need to be changed to Ying's NMI-safe single threaded lists).

You could use irq_work_queue() to push this into an irq context, which 
is user-return-notifier safe.

-- 
error compiling committee.c: too many arguments to function

