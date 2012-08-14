Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2HNCBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:01:15 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58518 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146Ab2HNCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:01:13 -0400
X-Sasl-enc: 1rTzVg8sR+JtZEOc8DfEuPWhUdLZyM4Bq3UwInNmWOm/ 1344909672
Date: Mon, 13 Aug 2012 19:01:11 -0700
From: Greg KH <greg@kroah.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Fixes a potential bug in android/logger.c
Message-ID: <20120814020111.GB26758@kroah.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
 <1343796860-7025-6-git-send-email-cruzjbishop@gmail.com>
 <5019C0D4.5010403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5019C0D4.5010403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:50:44AM +1000, Ryan Mallon wrote:
> On 01/08/12 14:54, Cruz Julian Bishop wrote:
> > Previously, when calling is_between(a, b, c), the calculation was wrong.
> > It counted C as between A and B if C was equal to B, but not A.
> > 
> > Example of this are:
> > 
> > is_between(1, 10, 10) = 1 (Expected: 0)
> > is_between(1, 10, 1) = 0 (Expected: 0)
> > is_between(20, 10, 10) = 1 (Expected: 0)
> > 
> > And so on and so forth.
> > 
> > Obviously, ten is not a number between one and ten - only two to eight are, so I made this patch :)
> 
> Is nine not a number between one and ten? :-p.
> 
> The question with a patch like this is whether the function's
> documentation, which says it returns 1 if a < c < b is wrong, or whether
> the implementation, which does a < c <= b is wrong. If the documentation
> is wrong, and something is relying on the current implementation, then
> this patch might actually break things.

I agree, which is correct?  I'd stick with the code for now, care to fix
the comment instead?

greg k-h
