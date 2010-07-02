Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0GBJeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:34:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab0GBJef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rnJZjE5JqJSG5MR7lIpkVk687euzHgWpnWsAoTBkwlXx+ul2/vJTk+xEjdLZiNLYPp
         YNYXzi2LgI+WeA23JTd2s5QseNcOtdH7H7ZsgdtgV47WcgImZmOfbqEupwk9cINdJrEX
         2FAYgaTmIQkPhg6RV5CykC6Y3rPPzDAcg3K28=
Message-ID: <4C2DB211.1030903@gmail.com>
Date: Fri, 02 Jul 2010 11:32:01 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 11:17 AM, Tejun Heo wrote:
> Hello, David, Arjan.
> 
> These four patches implement unbound workqueues which can be used as
> simple execution context provider.  I changed async to use it and will
> also make fscache use it.  This can be used by setting WQ_UNBOUND on
> workqueue creation.  Works queued to unbound workqueues are implicitly
> HIGHPRI and dispatched to unbound workers as soon as resources are
> available and the only limitation applied by workqueue code is
> @max_active.  IOW, for both async and fscache, things will stay about
> the same.
> 
> WQ_UNBOUND can serve the role of WQ_SINGLE_CPU.  WQ_SINGLE_CPU is
> dropped and replaced by WQ_UNBOUND.
> 
> Arjan, I still think we'll be better off using bound workqueues for
> async but let's first convert without causing behavior difference.
> Either way isn't gonna result in any noticeable difference anyway.  If
> you're okay with the conversion, please ack it.
> 
> David, this should work for fscache/slow-work the same way too.  That
> should relieve your concern, right?  Oh, and Frederic suggested that
> we would be better off with something based on tracing API and I
> agree, so the debugfs thing is currently dropped from the tree.  What
> do you think?

Oops, forgot something.  These four patches are on top of
wq#for-next-candidate branch which is cmwq take#6 + four fix patches

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next-candidate

and available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Thanks.

-- 
tejun
