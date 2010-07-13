Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0GMUgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:36:32 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:57010 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab0GMUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=subject
	:from:to:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=drama; b=Xbzf5
	bzSiEeSDwYC6jV/yNdqYSr8IEIiVN/qIn6LcTt1ZIkA4AB64QWG8Q4D42OiuNRfh
	4N/q8Wv1xYQMxa6UajPvDgQh7/AG9EIAuxfZekgwxv5hS+/dmRcPCodtAjtl4Iiy
	cVyFNqCbQ/0Vd2BSXvK0Dusjxh4w14XX+Oj5Ig=
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
In-Reply-To: <20100712214754.GC17978@basil.fritz.box>
References: <201007011744.19564.trenn@suse.de>
	 <201007091303.08693.trenn@suse.de> <20100709133019.GA2856@redhat.com>
	 <201007121624.17543.trenn@suse.de> <20100712162140.GA2925@redhat.com>
	 <20100712214754.GC17978@basil.fritz.box>
Content-Type: text/plain
Date: Tue, 13 Jul 2010 13:38:25 -0700
Message-Id: <1279053505.16225.9.camel@yehudasa-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 23:47 +0200, Andi Kleen wrote:
> On Mon, Jul 12, 2010 at 12:21:40PM -0400, Jason Baron wrote:
> > On Mon, Jul 12, 2010 at 04:24:16PM +0200, Thomas Renninger wrote:
> > > Hi,
> > > 
> > > it's this one:
> > > commit ff49d74ad383f54041378144ca1a229ee9aeaa59
> > > Author: Yehuda Sadeh <yehuda@hq.newdream.net>
> > > Date:   Sat Jul 3 13:07:35 2010 +1000
> > > 
> > > which touches same code than Jason's fix does.
> > > Possibly this patch also addresses (only parts of?) this problem?
> > > Jason: Do you mind having a look at the latest git version and review
> > > Yehuda's  and adjust your patch if still necessary.
> > 
> > So Yehuda's patch is meant to address this issue. I would still move the
> > remove code to free_module(), for the case that load_module() fails as
> > follows (on top of Yehuda's patch):
> 
> One of the known failures with this was a module that was just missing its exit
> function, but otherwise working. Is the patch likely to address this
> too? 
> 
I'm not sure about a known issue with a missing exit function. Looking
at the latest git, it doesn't seem there is a problem there. However,
there is an issue with the module init function returning an error.
Jason's fix on top of my patch solves it.

Yehuda

