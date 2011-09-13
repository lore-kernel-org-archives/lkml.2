Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1IMG3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:29:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50482 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1IMG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:29:21 -0400
Date: Tue, 13 Sep 2011 10:28:55 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
Message-ID: <20110913062855.GA3221@albatros>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
 <20110912150630.GE25367@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912150630.GE25367@sun>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 19:06 +0400, Cyrill Gorcunov wrote:
> On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
> > Historically /proc/slabinfo has 0444 permissions and is accessible to
> > the world.  slabinfo contains rather private information related both to
> > the kernel and userspace tasks.  Depending on the situation, it might
> > reveal either private information per se or information useful to make
> > another targeted attack.  Some examples of what can be learned by
> > reading/watching for /proc/slabinfo entries:
> > 
> ...
> 
> Since this file is controversy point, probably its permissions might be
> configurable via setup option?

We could create DEBUG_PROC (of cource, defaults to =n) to keep current
relaxed procfs permissions, but I don't think a configure option is needed
for a thing which is trivially done via "chmod" in init scripts.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
