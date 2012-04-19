Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2DSPeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab2DSPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:34:43 -0400
Date: Thu, 19 Apr 2012 11:34:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yurij.Plotnikov@oktetlabs.ru,
        davidel@xmailserver.org, nelhage@nelhage.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: clear the tfile_check_list on -ELOOP
Message-ID: <20120419153428.GA1596@redhat.com>
References: <201204171434.q3HEYqrq007242@int-mx09.intmail.prod.int.phx2.redhat.com>
 <20120417141315.703056a6.akpm@linux-foundation.org>
 <20120418045615.GU29100@oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418045615.GU29100@oktetlabs.ru>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 08:56:15AM +0400, Alexandra N. Kossovsky wrote:
> On Tue, Apr 17, 2012 at 02:13:15PM -0700, Andrew Morton wrote:
> > On Tue, 17 Apr 2012 10:34:52 -0400
> > Jason Baron <jbaron@redhat.com> wrote:
> > 
> > > An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
> > > circular epoll dependencies from being created. However, in that case
> > > we do not properly clear the 'tfile_check_list'. Thus, add a call to
> > > clear_tfile_check_list() for the -ELOOP case.
> > 
> > So here I am wondering what effect this bug has upon our users, so I
> > can decide which kernel versions should be fixed.  Jason didn't tell me
> > so I went to read the description of clear_tfile_check_list().  After a
> > brief chuckle, I stopped.
> > 
> > I then found Yurij's original report, so I know what's going on.  But I
> > still can't write your changelog because I don't know whether this is a
> > regression and if it is, which patch caused the regression.
> 
> It is a regression, somewhere between 3.2.6 and 3.2.9.
> Yurij and me blame
> commit 203aa5260edca2ab1872ad8b08386d874f7132f3
> Author: Jason Baron <jbaron@redhat.com>
> Date:   Thu Jan 12 17:17:43 2012 -0800
> but we have not tested it.
> 

Right, I introduced this with the upstream commit:

commit 28d82dc1c4edbc352129f97f4ca22624d1fe61de
Author: Jason Baron <jbaron@redhat.com>
Date:   Thu Jan 12 17:17:43 2012 -0800

    epoll: limit paths

So yes, this is a newly introduced regression.

Thanks,

-Jason
