Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab0DWKsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:48:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0DWKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:48:17 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <20100422155358.GE5805@quack.suse.cz>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
	 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
	 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
	 <1271931809.24780.387.camel@tucsk.pomaz.szeredi.hu>
	 <20100422155358.GE5805@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 12:48:17 +0200
Message-ID: <1272019697.24780.455.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 17:53 +0200, Jan Kara wrote:
> On Thu 22-04-10 12:23:29, Miklos Szeredi wrote:
> > I have very little understanding of I/O scheduling but my idea of what's
> > really needed here is to realize that one queue is not able to saturate
> > the device and there's a large backlog of requests on other queues that
> > are waiting to be served.  Is something like that implementable?
>   I see a problem with defining "saturate the device" - but maybe we could
> measure something like "completed requests / sec" and try autotuning
> slice_idle to maximize this value (hopefully the utility function should
> be concave so we can just use "local optimization").

Yeah, detecting saturation may be difficult.

I guess that function depends on a lot of other things as well,
including seek times, etc.  Not easy to optimize.

I'm still wondering what makes such a difference between CFQ on 2.6.16
and CFQ on 2.6.27-34, why is the one in older kernels performing so much
better in this situation?

What should we tell our customers?  The default settings should at least
handle these systems a bit better.

Thanks,
Miklos

