Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1GYGP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:15:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1GYGPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 02:15:53 -0400
Date: Mon, 25 Jul 2011 07:15:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725061551.GR24703@ZenIV.linux.org.uk>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
 <20110725015612.GB7603@redhat.com>
 <20110725024444.GP24703@ZenIV.linux.org.uk>
 <20110725045851.GA11267@redhat.com>
 <20110725051251.GQ24703@ZenIV.linux.org.uk>
 <20110725055307.GA12234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725055307.GA12234@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 01:53:08AM -0400, Dave Jones wrote:
> On Mon, Jul 25, 2011 at 06:12:51AM +0100, Al Viro wrote:
>  
>  > Arrgh...  OK, I see what's going on.
>  > 
>  >                                 req->err = handle(req->name, req->mode, req->dev);
>  >                                 complete(&req->done);
>  >                                 req = req->next;
>  > is letting the request creator to continue; if it leaves the scope, guess
>  > what is left in *req?  That's right, garbage...  Including req->next.
>  > All right, try this and let's see if it fixes the problem:
>  
> Yep, that solves the problem.

OK, to Linus it goes tomorrow morning...  I'm about to fall asleep right now
and queue needs a bit of reordering ;-/
