Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab0ECPDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:03:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759427Ab0ECPDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:03:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Mon, 3 May 2010 17:03:11 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
References: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005031703.11448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 May 2010, Alan Stern wrote:
> On Sun, 2 May 2010, Rafael J. Wysocki wrote:
> 
> > Hmm.  It doesn't seem to be possible to create two different suspend blockers
> > using the same file handle.  So, what exactly is a process supposed to do to
> > use two suspend blockers at the same time?
> 
> Open the file twice, thereby obtaining two file handles.

Well, that's what I thought.

I must admit I'm not really comfortable with this interface.  IMO it would
be better if _open() created the suspend blocker giving it a name based on
the name of the process that called it.  Something like
"<process name>_<timestamp>" might work at first sight.

Alternatively, "<process_name><number>", where <number> is 0 for the first
suspend blocker created by the given process, 1 for the second one etc., also
seems to be doable.

Rafael
