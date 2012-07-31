Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2GaJdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:33:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:65310 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab2GaJdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:33:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="190993319"
Date: Tue, 31 Jul 2012 17:33:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [vfs:fsfreeze] umount BUG: sleeping function called from invalid
 context
Message-ID: <20120731093342.GA15377@localhost>
References: <20120731083839.GC14475@localhost>
 <20120731085815.GF6481@ZenIV.linux.org.uk>
 <20120731091326.GA15095@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731091326.GA15095@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:13:26PM +0800, Fengguang Wu wrote:
> On Tue, Jul 31, 2012 at 09:58:15AM +0100, Al Viro wrote:
> > On Tue, Jul 31, 2012 at 04:38:39PM +0800, Fengguang Wu wrote:
> > > Hi Jan,
> > > 
> > > Here is another warning for the fs freeze series.
> > > 
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git fsfreeze
> > > head:   7aff72a61f45337d83ab2b7fb16d7b542db16ad8
> > > commit: bc875c078f72993e6c44925cdedef5a304ca7429 [37/51] fs: Improve filesystem freezing handling
> > > 
> > > The warning shows up reliably since commit bc875c0. The 2nd commit
> > > 51205f9 triggers the same warning as the previous email.
> > 
> > That one is fixed in the end of #fsfreeze (for testing purposes only) and then the right
> > way in #for-next (by making percpu_list_lock a  spinlock).
> 
> Ah sorry. It seems that you quickly pushed the fix
> 
>         commit c91dc212879946b8e542773394cb56e6e3c6e1ae
>         CommitDate: Tue Jul 31 01:57:53 2012 +0400
> 
>             [ewww][testing-only] deal with b0rken use of percpu_counter_destroy() under spinlock
> 
> while I'm still testing the slightly old head:
> 
>         commit 7aff72a61f45337d83ab2b7fb16d7b542db16ad8
>         CommitDate: Tue Jul 31 01:21:32 2012 +0400
> 
>             Documentation: Correct s_umount state for freeze_fs/unfreeze_fs

..and that's an easy to detect situation. I just told the test script
to double check latest HEAD before sending out the report :)

Thanks,
Fengguang
