Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031649Ab2CGAPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:15:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620Ab2CGAPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:15:45 -0500
Date: Tue, 6 Mar 2012 16:15:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: gaowanlong@cn.fujitsu.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        eparis@parisplace.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] selinux: init target class when add avc callback
Message-Id: <20120306161543.63c3fc54.akpm@linux-foundation.org>
In-Reply-To: <4F56A4E2.5050001@cn.fujitsu.com>
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<4F56A4E2.5050001@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2012 07:59:30 +0800
Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> On 02/05/2012 09:53 AM, Wanlong Gao wrote:
> 
> > Target security class should be initialized when add avc callback.
> > Although tclass is userless in callbacks now, but it may be used
> > in the future .
> > 
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > ---
> >  security/selinux/avc.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> > index dca1c22..27495e6 100644
> > --- a/security/selinux/avc.c
> > +++ b/security/selinux/avc.c
> > @@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
> >  	c->events = events;
> >  	c->ssid = ssid;
> >  	c->tsid = tsid;
> > +	c->tclass = tclass;
> >  	c->perms = perms;
> >  	c->next = avc_callbacks;
> >  	avc_callbacks = c;

Perhaps James can take a look at this?

avc_add_callback() looks a bit odd.  It uses GFP_ATOMIC, but that is
unnecessary because avc_add_callback() is only ever called from
module_init() code.  And if it isn't only ever called from
module_init() code then it needs some locking for that list.
