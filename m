Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab2FGBbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab2FGBbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:31:42 -0400
Date: Wed, 6 Jun 2012 21:31:12 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607013112.GB17566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607012900.GE30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 02:29:00AM +0100, Al Viro wrote:
 > On Wed, Jun 06, 2012 at 09:19:15PM -0400, Dave Jones wrote:
 > > On Wed, Jun 06, 2012 at 05:42:35PM -0700, Linus Torvalds wrote:
 > > 
 > >  > So Al meant you to test mutex_is_locked(dentry->d_inode->i_mutex) of
 > >  > the parents.
 > > 
 > > ok, I ended up with..
 > > 
 > >         WARN_ON_ONCE(!mutex_is_locked(&target->d_parent->d_inode->i_mutex));
 > > 
 > >         if (dentry->d_parent != NULL)
 > 			       != dentry)
 > 
 > ->d_parent *never* should be NULL; when dentry is disconnected from the
 > tree (or hadn't been connected to it yet), it points to that dentry itself.

ah, thanks. My VFS ignorance showing there.

	Dave
