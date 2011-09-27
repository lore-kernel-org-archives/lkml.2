Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab1I0S13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:27:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1I0S12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:27:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=IHCzk3blIlNlMaRnfNnvinkj0Mz9Lu0f3ojkUyPD2FxRYqwTFjLnuVDDOp7wxPD9J
	i7fNnJUGFXNGO/Rw8LmaQ==
Date: Tue, 27 Sep 2011 11:27:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vasiliy Kulikov <segoon@openwall.com>
cc: kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: <20110927175642.GA3432@albatros>
Message-ID: <alpine.DEB.2.00.1109271122480.17876@chino.kir.corp.google.com>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Vasiliy Kulikov wrote:

> /proc/meminfo stores information related to memory pages usage, which
> may be used to monitor the number of objects in specific caches (and/or
> the changes of these numbers).  This might reveal private information
> similar to /proc/slabinfo infoleaks.  To remove the infoleak, just
> restrict meminfo to root.  If it is used by unprivileged daemons,
> meminfo permissions can be altered the same way as slabinfo:
> 
>     groupadd meminfo
>     usermod -a -G meminfo $MONITOR_USER
>     chmod g+r /proc/meminfo
>     chgrp meminfo /proc/meminfo
> 

I guess the side-effect of this is that users without root will no longer 
report VM issues where "there's tons of freeable memory but my task got 
killed", "there's swap available but is unutilized in lowmem situations", 
etc. :)

Seriously, though, can't we just change the granularity of /proc/meminfo 
to be MB instead of KB or at least provide a separate file that is 
readable that does that?  I can understand not exporting information on a 
page-level granularity but not giving users a way to determine the amount 
of free memory is a little extreme.
