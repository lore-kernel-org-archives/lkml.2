Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2LRTwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:52:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49116 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753999Ab2LRTws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:52:48 -0500
Message-ID: <1355860368.30366.33.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on #include <uapi/...
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 11:52:48 -0800
In-Reply-To: <12373.1355858223@warthog.procyon.org.uk>
References: <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com>
	 <6433.1355840610@warthog.procyon.org.uk>
	 <12373.1355858223@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 19:17 +0000, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
> 
> > +			if ($path =~ "^uapi/") {
> > +				ERROR("UAPI_INCLUDE",
> > +				      "#include should not start with uapi/\n" . $herecurr);
> >  			}
> 
> But does this limit the check only to headers in uapi/ directories?

No.  I'm confused, I believe your example was:

arch/powerpc/include/asm/kvm_para.h
@@ -16,77 +16,11 @@
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
  */
-
 #ifndef __POWERPC_KVM_PARA_H__
 #define __POWERPC_KVM_PARA_H__
 
-#include <linux/types.h>
+#include <uapi/asm/kvm_para.h>

---------------

What do you want this to check?


