Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1ASP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:56:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33006 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1ASP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:56:13 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Cc: Liuwenyi <qingshenlwy@gmail.com>, strongzgy <strongzgy@gmail.com>,
        onlyflyer <onlyflyer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, ak <ak@linux.intel.com>,
        akpm <akpm@linux-foundation.org>, miaox <miaox@cn.fujitsu.com>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        meego-kernel <meego-kernel@meego.com>
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
In-reply-to: <20110119141334.GA2544@localhost.localdomain>
References: <4D36F04D.70505@gmail.com> <20110119141334.GA2544@localhost.localdomain>
Date: Wed, 19 Jan 2011 10:52:16 -0500
Message-Id: <1295452288-sup-8924@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Josef Bacik's message of 2011-01-19 09:14:02 -0500:
> On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
> > In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
> > null pointer in test_range_bit() while lock the spinlock.
> > 
> > So, It is necessary to add a pointer check into test_range_bit()
> > 
> 
> 
> NAK, the tree shouldn't be null coming into this function, something else is
> going wrong.  What oops is this?  Thanks,

What was your metadata blocksize for this oops?  This call should never
happen.

I think there is a larger problem, probably in the IO error handling
code since the trace had io errors beforehand.

-chris
