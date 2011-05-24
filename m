Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1EXQuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:50:04 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:34342 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1EXQuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:50:02 -0400
Date: Tue, 24 May 2011 18:49:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Hiromu Yakura <hiromu1996@gmail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        zippel@linux-m68k.org
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
Message-ID: <20110524164935.GA18458@merkur.ravnborg.org>
References: <1306167401.18840.8.camel@hiromu-MacBook> <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com> <1306242400.7501.10.camel@hiromu-MacBook> <4DDBB150.2090602@suse.cz> <1306247192.7501.25.camel@hiromu-MacBook> <4DDBC846.8050402@suse.cz> <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>
> >>> Arnaud's point is that your patch should not be necessary at all,
> >>> because kconfig already checks the return value of the fopen() call in
> >>> conf_write() and prints the above message if it fails. So do you have a
> >>> testcase where make<...>config without your patch returns without
> >>> error, but the configuration is not written?
> >>
> >> Sorry for misunderstanding.
> >> Indeed, make *config which use 'conf' (e.g. oldconfig, defconfig...)
> >> raise error.
> >> And only xconfig and gconfig don't write the configuration without
> >> error.
> >
> > I see, qconf lacks a check for the return value of conf_write() in
> > ConfigMainWindow::closeEvent(), gconf does check the return value, but only
> > displays it in the bottom box of the main window instead of a message box.
> > Neither of them return failure in the error case. These bugs should be
> > indeed fixed.
> >
> agree.
The only thing that a write-access check up-front could be useful for would be
to launch a front-end in ReadOnly mode.
And this is not supported by any of them today IIRC.

	Sam
