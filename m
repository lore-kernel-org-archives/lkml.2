Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab1IHLtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 07:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324Ab1IHLtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 07:49:11 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 07:48:27 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-96.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Stephan Mueller <stephan.mueller@atsec.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jarod Wilson <jarod@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67E1B0.2040309@atsec.com> <20110908084420.GC4032@infradead.org>
In-Reply-To: <20110908084420.GC4032@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109080748.27750.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 08, 2011 04:44:20 AM Christoph Hellwig wrote:
> On Wed, Sep 07, 2011 at 11:27:12PM +0200, Stephan Mueller wrote:
> > And exactly that is the concern from organizations like BSI. Their
> > cryptographer's concern is that due to the volume of data that you can
> > extract from /dev/urandom, you may find cycles or patterns that increase
> > the probability to guess the next random value compared to brute force
> > attack. Note, it is all about probabilities.
> 
> So don't use /dev/urandom if you don't like the behaviour.  Breaking all
> existing application because of a certification is simply not an option.

This patch does not _break_ all existing applications. If a system were under attack, 
they might pause momentarily, but they do not break. Please, try the patch and use a 
nice large number like 2000000 and see for yourself. Right now, everyone arguing about 
this breaking things have not tried it to see if in fact things do break and how they 
break if they do.

-Steve
