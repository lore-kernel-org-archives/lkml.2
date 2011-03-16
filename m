Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1CPWeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:34:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab1CPWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:34:07 -0400
Date: Wed, 16 Mar 2011 15:33:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, maximlevitsky@gmail.com,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
Message-Id: <20110316153321.8345606a.akpm@linux-foundation.org>
In-Reply-To: <403815.22502.qm@web37607.mail.mud.yahoo.com>
References: <20110316113527C.fujita.tomonori@lab.ntt.co.jp>
	<403815.22502.qm@web37607.mail.mud.yahoo.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 21:18:14 -0700 (PDT)
Alex Dubov <oakad@yahoo.com> wrote:

> 
> > 
> > I don't think so.
> > 
> > Splitting (or merging) a request and playing with sg lists
> > inside a
> > driver is a bad idea. Such should be done in the block
> > layer.
> > 
> > I still don't see why the block layer can't do that for the
> > driver.
> > 
> > I believe that the helper functions for such should not be
> > added.
> > 
> 
> 
> In a particular case of flash-like devices, letting the block layer
> split requests into memory sequential blocks too often results in
> unnecessary fragmentation of writes/erases.
> 
> If only one sg entry is requested from the block layer, it will be (more
> often than not) only 1 or 2 pages in length, even if total size of
> prospective write request spans multiple erase blocks.
> 
> So there are really only two options for legacy memorystick driver:
> 1. Play with scatterlists explicitly.
> 2. Make it an MTD backend, rather then stand-alone block device.
> 
> The second option makes more sense, but it is not necessarily the optimal
> approach for implementation of this particular media format.
> 

Thanks.

Do you believe that any other driver is likely to ue the sg
infrastructure which this patch adds?  Should those additions be 
internal to the memstick code, at least for now?
