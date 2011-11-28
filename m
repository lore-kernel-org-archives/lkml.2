Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1K1ROE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:14:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47040 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560Ab1K1ROC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:14:02 -0500
Message-ID: <1322500440.2024.24.camel@Joe-Laptop>
Subject: Re: [PATCH] 9p: Reduce object size with CONFIG_NET_9P_DEBUG
From: Joe Perches <joe@perches.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 28 Nov 2011 09:14:00 -0800
In-Reply-To: <CAFkjPTmyn9POfTjYYjjYEaPt6M6Wdu-P=SEc=ZeTsbA+1=VraA@mail.gmail.com>
References: <1321661394.5917.7.camel@Joe-Laptop>
	 <CAFkjPTmyn9POfTjYYjjYEaPt6M6Wdu-P=SEc=ZeTsbA+1=VraA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 09:10 -0600, Eric Van Hensbergen wrote:
> sorry, just got to reviewing this because of holidays.
> 
> On Fri, Nov 18, 2011 at 6:09 PM, Joe Perches <joe@perches.com> wrote:
> > Reduce object size by deduplicating formats.
> >
> > Use vsprintf extension %pV.
> > Rename P9_DPRINTK uses to p9_debug, align arguments.
> > Add function for _p9_debug and macro to add __func__.
> > Add missing "\n"s to p9_debug uses.
> > Remove embedded function names as p9_debug adds it.
> > Remove P9_EPRINTK macro and convert use to pr_<level>.
> > Add and use pr_fmt and pr_<level>.
> >
> > $ size fs/9p/built-in.o*
> >   text    data     bss     dec     hex filename
> >  62133     984   16000   79117   1350d fs/9p/built-in.o.new
> >  67342     984   16928   85254   14d06 fs/9p/built-in.o.old
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> These changes seem reasonable enough, but since you only made changes
> in the fs/9p directory and not the net/9p directory which causes
> net/9p build to break with this patch.
> 
> CC      net/9p/client.o
> /home/ericvh/src/linux/v9fs-devel/net/9p/client.c: In function
> ‘get_protocol_version’:
> /home/ericvh/src/linux/v9fs-devel/net/9p/client.c:84:3: error:
> implicit declaration of function ‘P9_DPRINTK’

Sorry 'bout that.
I'll fix it and resubmit later.

