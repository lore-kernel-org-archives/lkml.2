Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1GYFxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 01:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1GYFxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 01:53:10 -0400
Date: Mon, 25 Jul 2011 01:53:08 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725055307.GA12234@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
 <20110725015612.GB7603@redhat.com>
 <20110725024444.GP24703@ZenIV.linux.org.uk>
 <20110725045851.GA11267@redhat.com>
 <20110725051251.GQ24703@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725051251.GQ24703@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 06:12:51AM +0100, Al Viro wrote:
 
 > Arrgh...  OK, I see what's going on.
 > 
 >                                 req->err = handle(req->name, req->mode, req->dev);
 >                                 complete(&req->done);
 >                                 req = req->next;
 > is letting the request creator to continue; if it leaves the scope, guess
 > what is left in *req?  That's right, garbage...  Including req->next.
 > All right, try this and let's see if it fixes the problem:
 
Yep, that solves the problem.

	Dave 
