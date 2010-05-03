Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0ECV1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:27:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35849 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab0ECV1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <201005031703.11448.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org>
	 <201005031703.11448.rjw@sisk.pl>
Date: Mon, 3 May 2010 14:26:59 -0700
Message-ID: <m2yd6200be21005031426n87ea43a0k968fd5898ce0b873@mail.gmail.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
	blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 8:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 02 May 2010, Alan Stern wrote:
>> On Sun, 2 May 2010, Rafael J. Wysocki wrote:
>>
>> > Hmm.  It doesn't seem to be possible to create two different suspend blockers
>> > using the same file handle.  So, what exactly is a process supposed to do to
>> > use two suspend blockers at the same time?
>>
>> Open the file twice, thereby obtaining two file handles.
>
> Well, that's what I thought.
>
> I must admit I'm not really comfortable with this interface.  IMO it would
> be better if _open() created the suspend blocker giving it a name based on
> the name of the process that called it.  Something like
> "<process name>_<timestamp>" might work at first sight.
>
> Alternatively, "<process_name><number>", where <number> is 0 for the first
> suspend blocker created by the given process, 1 for the second one etc., also
> seems to be doable.

I think it is important to let user-space specify the name. If a
process uses multiple suspend blockers, it is impossible to tell what
each one is used for if they are automatically named.

-- 
Arve Hjønnevåg
