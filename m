Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2HAUIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:08:32 -0400
Received: from lola.svc-box.de ([82.149.231.63]:57243 "EHLO lola.svc-box.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2HAUIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:08:30 -0400
Date: Wed, 1 Aug 2012 22:08:29 +0200
From: Tino Reichardt <list-linux-fsdevel@mcmilk.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net
Subject: Re: [Jfs-discussion] [PATCH] fs/jfs: TRIM support for JFS
 Filesystem
Message-ID: <20120801200829.GA30608@mcmilk.de>
References: <20120726213219.GA28330@mcmilk.de>
 <20120728110805.GA690@mcmilk.de>
 <50185916.7010705@oracle.com>
 <20120801192934.GB19139@mcmilk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801192934.GB19139@mcmilk.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tino Reichardt <list-linux-fsdevel@mcmilk.de> wrote:
> * Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> > On 07/28/2012 06:08 AM, Tino Reichardt wrote:
> > > * Tino Reichardt <list-linux-fsdevel@mcmilk.de> wrote:
> > >> > This patch adds support for the two linux interfaces of the discard/TRIM
> > >> > command for SSD devices and sparse/thinly-provisioned LUNs.
> > > Fixed a problem when setting minlen in jfs_ioc_trim().

Oops, setting minlen in jfs_ioc_trim() was again wrong :/

I changed this
if (minlen < 0)
	minlen = 1;

to this:
if (minlen <= 0)
	minlen = 1;

This is important, since fstrim() sets it to zero.


Fully working patch is located here:
http://www.mcmilk.de/projects/jfs-trim/linux-tree/jfs-trim-2012-08-01_v2.diff

Signed-off-by: Tino Reichardt <list-jfs@mcmilk.de>

-- 
regards, TR
