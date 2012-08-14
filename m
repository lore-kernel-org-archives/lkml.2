Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2HNEIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 00:08:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53403 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2HNEIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 00:08:52 -0400
Message-ID: <1344917324.25753.0.camel@Cruz-Laptop>
Subject: Re: [PATCH 5/5] Fixes a potential bug in android/logger.c
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ryan Mallon <rmallon@gmail.com>, swetland@google.com,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Aug 2012 14:08:44 +1000
In-Reply-To: <20120814020111.GB26758@kroah.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
	 <1343796860-7025-6-git-send-email-cruzjbishop@gmail.com>
	 <5019C0D4.5010403@gmail.com> <20120814020111.GB26758@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 19:01 -0700, Greg KH wrote:
> On Thu, Aug 02, 2012 at 09:50:44AM +1000, Ryan Mallon wrote:
> > On 01/08/12 14:54, Cruz Julian Bishop wrote:
> > > Previously, when calling is_between(a, b, c), the calculation was wrong.
> > > It counted C as between A and B if C was equal to B, but not A.
> > > 
> > > Example of this are:
> > > 
> > > is_between(1, 10, 10) = 1 (Expected: 0)
> > > is_between(1, 10, 1) = 0 (Expected: 0)
> > > is_between(20, 10, 10) = 1 (Expected: 0)
> > > 
> > > And so on and so forth.
> > > 
> > > Obviously, ten is not a number between one and ten - only two to eight are, so I made this patch :)
> > 
> > Is nine not a number between one and ten? :-p.
> > 
> > The question with a patch like this is whether the function's
> > documentation, which says it returns 1 if a < c < b is wrong, or whether
> > the implementation, which does a < c <= b is wrong. If the documentation
> > is wrong, and something is relying on the current implementation, then
> > this patch might actually break things.
> 
> I agree, which is correct?  I'd stick with the code for now, care to fix
> the comment instead?
> 
> greg k-h

Sure, I'll send a new patch for it soon


