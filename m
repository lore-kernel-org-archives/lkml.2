Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299Ab1GMKor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016Ab1GMKoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:44:46 -0400
Date: Wed, 13 Jul 2011 06:44:04 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, helge.hafting@hist.no
Subject: Re: [stable] [PATCH] cifs: fix wsize negotiation for 2.6.39 stable
Message-ID: <20110713064404.668d42a5@tlielax.poochiereds.net>
In-Reply-To: <20110713022619.GA11043@kroah.com>
References: <1310520281-17467-1-git-send-email-jlayton@redhat.com>
	<20110713022619.GA11043@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 04:26:19 +0200
Greg KH <greg@kroah.com> wrote:

> On Tue, Jul 12, 2011 at 09:24:41PM -0400, Jeff Layton wrote:
> > I sent this a week or so ago, but it apparently missed the recent
> > 2.6.39.y release. Resending to make sure it gets into the next one.
> > 
> > Prior to 2.6.39, when signing was enabled on a socket the client only
> > sent single-page writes. This changed with commit ca83ce3d5b, which
> > made signed and unsigned connections use the same codepaths for write
> > calls.
> > 
> > This caused a regression when working with windows servers. Windows
> > machines will reject writes larger than the MaxBufferSize when signing
> > is active, but does not clear the CAP_LARGE_WRITE_X flag in the
> > negotiation.
> > 
> > This patch backports 2 patches that fix this problem in 3.0 kernels,
> > and changes a couple of the constants to values appropriate for the
> > writeback code in 2.6.39.
> 
> Why not just tell me the 2 patches in upstream that need to be
> backported as Documentation/stable_kernel_rules.txt say to do instead?
> 
> thanks,
> 
> greg k-h

Ok, we can do it that way instead. I just sent a patch to
stable@kernel.org that alters the constants after listing the upstream
patches as prerequisites.

Unfortunately, we cannot simply cherry-pick the upstream patches to fix
this. 3.0 added support for much larger wsize= values in cifs, and we
have to account for that difference in 2.6.39.y.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
