Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0I2UPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:15:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0I2UPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:15:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SQ7PkbCBXAvgq7itTkaJ/SZLUTTsRIuNxOHxNPInIaN+k4UpCkQ1vuutFR6+6kXMh
	2ZK1mScRd0dcW8TxYE+RQ==
Date: Wed, 29 Sep 2010 13:15:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Namhyung Kim <namhyung@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: Add lock release annotation
In-Reply-To: <1285761735-31499-2-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.DEB.2.00.1009291314570.9797@chino.kir.corp.google.com>
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com> <1285761735-31499-2-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, Namhyung Kim wrote:

> The unfreeze_slab() releases page's PG_locked bit but was missing
> proper annotation. The deactivate_slab() needs to be marked also
> since it calls unfreeze_slab() without grabbing the lock.

unfreeze_slab() needs it because it calls deactivate_slab() 
unconditionally, rather.

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
