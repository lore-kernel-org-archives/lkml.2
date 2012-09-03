Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2ICEYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 00:24:53 -0400
Received: from linux-sh.org ([111.68.239.195]:48761 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2ICEYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 00:24:52 -0400
Date: Mon, 3 Sep 2012 13:24:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can not get output of command line on SH
Message-ID: <20120903042442.GE20229@linux-sh.org>
References: <CABMQnVL4Dnee48aQs6Bhmqt5uu_T=Ro72E47sOWcS2CyZTtu4w@mail.gmail.com>
 <20120831131020.GB23464@ZenIV.linux.org.uk>
 <CABMQnVKDWN6xftShR_Xt6Odc-jPMSKnU+fqDY+v0tofaM=PTJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABMQnVKDWN6xftShR_Xt6Odc-jPMSKnU+fqDY+v0tofaM=PTJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 11:56:59AM +0900, Nobuhiro Iwamatsu wrote:
> On Fri, Aug 31, 2012 at 10:10 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Smells like broken TIF_NOTIFY_RESUME hookup on sh...  Arrrgh.  Looks like
> > while it is in the relevant masks *and* checked in do_notify_resume() both
> > on 32bit and 64bit variants since commit ab99c733ae73cce31f2a2434f7099564e5a73d95
> > Author: Paul Mundt <lethal@linux-sh.org>
> > Date:   Wed Jul 30 19:55:30 2008 +0900
> >
> >     sh: Make syscall tracer use tracehook notifiers, add TIF_NOTIFY_RESUME.
> >
> > they are actually *not* reached without simulataneous SIGPENDING, since the
> > actual glue in the callers had not been updated back then and still checks
> > for _TIF_SIGPENDING alone when deciding whether to hit do_notify_resume()
> > or not.  Looks like the following ought to fix that:
> 
> Thanks for your reply and explanation.
> I confirmed that revise this problem with your patch.
> 
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> 
I'll queue it up, thanks!
