Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1HSPBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab1HSPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:01:14 -0400
Date: Fri, 19 Aug 2011 16:58:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110819145815.GA15420@redhat.com>
References: <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de> <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop> <20110818184857.GA12094@redhat.com> <1313717521.991.4.camel@mop> <20110819122503.GA8411@redhat.com> <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com> <20110819131339.GB8411@redhat.com> <1313763653.1119.12.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763653.1119.12.camel@mop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Kay Sievers wrote:
>
> On Fri, 2011-08-19 at 15:13 +0200, Oleg Nesterov wrote:
> > On 08/19, Kay Sievers wrote:
>
> > But this has other (OK, minor) problems too, afaics. First of all, this
> > ->has_child_subreaper = T is not right when the caller exits. We should
> > not look for ->is_child_subreaper parent, our children should to find us.
> >
> > Right?
>
> The flags are still inherited. If the subreaper isn't there anymore, we
> will look it up and not find it. I think that's ok for the very unusual
> case that a service manager goes away and its children still run. We
> will just fall back to the usual PID 1 logic.

Yes, yes, I didn't mean this is really buggy. Just a bit "strange".
Anyway, this is fixed in v4 you sent.

> version 4:

Looks correct... But I don't trust myself. Especially after I missed
the problem with klthreads ;)

I'll try to re-read this patch carefully tomorrow with a fresh head.

Oleg.

