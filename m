Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0DMGbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0DMGbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:31:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
In-Reply-To: Oleg Nesterov's message of  Monday, 12 April 2010 21:50:42 +0200 <20100412195042.GA14108@redhat.com>
References: <20100322184136.GA3967@redhat.com>
	<15829.1269333449@redhat.com>
	<20100323105707.GA8634@redhat.com>
	<20100409195936.44663BD18@magilla.sf.frob.com>
	<20100412195042.GA14108@redhat.com>
X-Windows: flaky and built to stay that way.
Message-Id: <20100413063013.A0759B06B@magilla.sf.frob.com>
Date: Mon, 12 Apr 2010 23:30:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, /proc/pid/status can report the intermediate state, I even sent
> the updated changelog to document this.
> 
> But if you are not sure this is OK, I am worried. Do you think we should
> drop this patch? If yes, I won't argue.

I'm not dead-set against it, but I am hesitant.  My inclination is not to
remove any previous userland atomicity guarantees with regard to observable
signal state in any form.  At least, don't do that in part of a whole
cleanup flurry where it is intermixed with lots of changes that really are
pure cleanup with absolutely no userland-observable change.  If it really
helps to fragment what was atomic before, then we can consider it.  But
let's not be in a hurry.

David mentioned that users who do multiple reads due to using tiny buffers
already don't get atomic sampling.  That is certainly true but I don't
think it's relevant.  It is completely reliable that you can easily
allocate a buffer big enough to get all the Sig* fields on the first read,
and any user program that might care about the coherence of the data,
by definition, is already doing that.


Thanks,
Roland
