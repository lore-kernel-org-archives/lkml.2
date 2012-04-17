Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2DQVNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2DQVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:13:17 -0400
Date: Tue, 17 Apr 2012 14:13:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Yurij.Plotnikov@oktetlabs.ru, Alexandra.Kossovsky@oktetlabs.ru,
        davidel@xmailserver.org, nelhage@nelhage.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: clear the tfile_check_list on -ELOOP
Message-Id: <20120417141315.703056a6.akpm@linux-foundation.org>
In-Reply-To: <201204171434.q3HEYqrq007242@int-mx09.intmail.prod.int.phx2.redhat.com>
References: <201204171434.q3HEYqrq007242@int-mx09.intmail.prod.int.phx2.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 10:34:52 -0400
Jason Baron <jbaron@redhat.com> wrote:

> An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
> circular epoll dependencies from being created. However, in that case
> we do not properly clear the 'tfile_check_list'. Thus, add a call to
> clear_tfile_check_list() for the -ELOOP case.

So here I am wondering what effect this bug has upon our users, so I
can decide which kernel versions should be fixed.  Jason didn't tell me
so I went to read the description of clear_tfile_check_list().  After a
brief chuckle, I stopped.

I then found Yurij's original report, so I know what's going on.  But I
still can't write your changelog because I don't know whether this is a
regression and if it is, which patch caused the regression.

Wanna help out here please?

