Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2ISMDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:03:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40223 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2ISMDy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 19 Sep 2012 08:03:54 -0400
Message-Id: <5059D0C8020000780009C4CF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 19 Sep 2012 13:03:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Oliver Chick" <oliver.chick@citrix.com>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk
 drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
In-Reply-To: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.09.12 at 12:51, Oliver Chick <oliver.chick@citrix.com> wrote:
> +/*
> + * Maximum number of persistent grants that can be mapped by Dom0 for each
> + * interface. This is set to be the size of the ring, as this is a limit on
> + * the number of requests that can be inflight at any one time. 256 imposes
> + * an overhead of 11MB of mapped kernel space per interface.
> + */
> +#define BLKIF_MAX_PERS_REQUESTS_PER_DEV 256

How can this be a fixed number, especially in the context of ring
size extensions? Iirc, single page rings can accommodate 64
requests, so I'd guess the number above was observed with a
4-page (order 2) ring...

Jan

