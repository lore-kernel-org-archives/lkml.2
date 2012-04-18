Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2DRE4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:56:35 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:42982 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934Ab2DRE4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:56:33 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 691317F4DE
Authentication-Results: shelob.oktetlabs.ru/691317F4DE; dkim=none
	(no signature) header.i=unknown; dkim-adsp=none
Date: Wed, 18 Apr 2012 08:56:15 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, Yurij.Plotnikov@oktetlabs.ru,
        davidel@xmailserver.org, nelhage@nelhage.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: clear the tfile_check_list on -ELOOP
Message-ID: <20120418045615.GU29100@oktetlabs.ru>
References: <201204171434.q3HEYqrq007242@int-mx09.intmail.prod.int.phx2.redhat.com>
 <20120417141315.703056a6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417141315.703056a6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 02:13:15PM -0700, Andrew Morton wrote:
> On Tue, 17 Apr 2012 10:34:52 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
> > circular epoll dependencies from being created. However, in that case
> > we do not properly clear the 'tfile_check_list'. Thus, add a call to
> > clear_tfile_check_list() for the -ELOOP case.
> 
> So here I am wondering what effect this bug has upon our users, so I
> can decide which kernel versions should be fixed.  Jason didn't tell me
> so I went to read the description of clear_tfile_check_list().  After a
> brief chuckle, I stopped.
> 
> I then found Yurij's original report, so I know what's going on.  But I
> still can't write your changelog because I don't know whether this is a
> regression and if it is, which patch caused the regression.

It is a regression, somewhere between 3.2.6 and 3.2.9.
Yurij and me blame
commit 203aa5260edca2ab1872ad8b08386d874f7132f3
Author: Jason Baron <jbaron@redhat.com>
Date:   Thu Jan 12 17:17:43 2012 -0800
but we have not tested it.

-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
