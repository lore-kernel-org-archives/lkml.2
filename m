Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0ETRs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:48:58 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47525 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0ETRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:48:57 -0400
Date: Thu, 20 May 2010 19:48:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
Message-ID: <20100520174855.GV25951@kernel.dk>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> <20100519180554.GY25951@kernel.dk> <20100519190510.GZ25951@kernel.dk> <E1OF1C0-0007mV-VZ@pomaz-ex.szeredi.hu> <20100520083732.GI25951@kernel.dk> <alpine.LFD.2.00.1005201041320.23538@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005201041320.23538@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20 2010, Linus Torvalds wrote:
> 
> 
> On Thu, 20 May 2010, Jens Axboe wrote:
> > 
> > The main reason I didn't push it before is that I wasn't completely sure
> > that we wanted to use fcntl() for this. But Linus doesn't seem to object
> > on that side at least.
> 
> Well, I don't object as long as there is some real use-case. If it's a 
> "feature just for the sake of the feature" kind of theoretical "shouldn't 
> we be able to do this" thing, I don't think we should do it.
> 
> But it sounded like Miklos actually had a reason for the request. 

Yeah, I'd say his 4x results pretty much speak for themselves. I've
observed splice being slower as well here for high bandwidth testing,
the 64kb max buffer size ends up hurting there. So I'm very convinced
that this is a good idea. I have been for a while, was just waiting for
someone else to pop up with an independent need and results to help
shove it in :-)

-- 
Jens Axboe

