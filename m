Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2BVQ3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:29:46 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23272 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943Ab2BVQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:29:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JK93eYcVM1nczfCVu96Vt_PTjE0OZbdI6ZJ3BZiwjQLRo1_
 YPAfeyUGOXnWPRbK9EUrFsPE67L2Qe9A0KtvXdJRS1E0PVUG_P7IDukzI7vs
 6E5jSJymtiiR2KQOOGMRBkZurc_R3ucu8iWfNNSS.sqZFP7bR64QQt6qzCho
 wgmdV6hXOJZ3d6fm5XUcXHmrrtnK5nBaoAcnEBn.gmSnaewRx1nvCdO.GfcL
 f5W8Wp.NJWtQWR5GdnMEnmHzw2vmaT6pHXlGEmjwS5oRC0MjKkFm1bQb9ymq
 9QQGyhZBBw.tKZY5roSSF_q7WUA9SQm1W0ic3edrjjG7pJ7uje5ykfdODMvq
 QxCCz3EhmgnaXuuwVwoEDmpW92lgNvQusztkBfTO2vkAPrBigBP466tc.gA8
 y2Pjr6UbjQ9r1rTT.CJL7YzbbhedEHD5OZQpn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 22 Feb 2012 10:29:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <20120222161440.GB1986@x61.redhat.com>
Message-ID: <alpine.DEB.2.00.1202221028340.10258@router.home>
References: <20120222115320.GA3107@x61.redhat.com> <alpine.DEB.2.00.1202220754140.21637@router.home> <20120222161440.GB1986@x61.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012, Rafael Aquini wrote:

> On Wed, Feb 22, 2012 at 07:55:16AM -0600, Christoph Lameter wrote:
> >
> > Please use node_nr_objects() instead of directly accessing total_objects.
> > total_objects are only available if debugging support was compiled in.
> >
> Shame on me! I've wrongly assumed that it would be safe accessing
> the element because SLUB_DEBUG is turned on by default when slub is chosen.
>
> Considering your note on my previous mistake, shall I assume now that it
> would be better having this whole dump feature dependable on CONFIG_SLUB_DEBUG,
> instead of just CONFIG_SLUB ?

That is certainly one solution. If CONFIG_SLUB_DEBUG is not set then
support for maintaining a total count is not compiled in. You can of
course still approximate that from the total number of slabs allocated and
multiply that number by the # of objs per slab page.

