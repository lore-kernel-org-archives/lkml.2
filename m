Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0KUIb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:31:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0KUIb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:31:56 -0500
Date: Sun, 21 Nov 2010 10:31:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: teach checkpatch about rcu
Message-ID: <20101121083121.GA15587@redhat.com>
References: <20101118170515.GA14005@redhat.com>
 <1290100547.2781.206.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290100547.2781.206.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 06:15:47PM +0100, Eric Dumazet wrote:
> Le jeudi 18 novembre 2010 à 19:05 +0200, Michael S. Tsirkin a écrit :
> > I got this:
> > +       struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
> > which is because checkpatch does not know about __rcu.
> > So here's a patch to teach it about that tag.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  scripts/checkpatch.pl |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 2039acd..1b11c8e 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -143,6 +143,7 @@ our $Sparse	= qr{
> >  			__must_check|
> >  			__init_refok|
> >  			__kprobes|
> > +			__rcu|
> >  			__ref
> >  		}x;
> >  
> 
> 
> Hmm, why __percpu is in $Attribute, and __rcu in $Sparse ?
> 

I can't say: we have __kernel and __user and __iomem address spaces in $Sparse
and only __percpu in $Attribute, so I thought address spaces belong in
$Sparse and __percpu just sneaked in there with a ton of other
attributes added by 03f1df7da5696ddfa6e167b37e0c0ce5aad3de79.

Should __percpu be moved to $Sparse perhaps?

-- 
MST

