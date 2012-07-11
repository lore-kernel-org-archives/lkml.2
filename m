Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2GKLGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:06:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:41322 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752668Ab2GKLGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120711020902.GC13885@ram-ThinkPad-T61>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
	<20120710143348.d977da44.akpm@linux-foundation.org>
	<20120711020902.GC13885@ram-ThinkPad-T61>
Date: Wed, 11 Jul 2012 14:06:10 +0300
Message-ID: <CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
From: "Purdila, Octavian" <octavian.purdila@intel.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:09 AM, Ram Pai <linuxram@us.ibm.com> wrote:

>
> Wait.. I am not sure this will fix the problem entirely. The above check
> will handle the case where the range requested is entirey out of the
> root's range.  But if the requested range overlapps that of the root
> range, we will still call __reserve_region_with_split() and end up with
> a recursion if there is a overflow. Wont we?
>

Good catch. I will fix this as well as address Andrew's and Joe's
comments in a new patch. The only question is how to handle the
overlap case:

(a) abort the whole request or

(b) try to reserve the part that overlaps (and adjust the request to
avoid the overflow)

I think (b) is more in line with the current implementation for reservations.
