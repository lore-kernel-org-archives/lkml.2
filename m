Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0JMOrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:47:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0JMOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nG+V9R1XL7U8+lAg9yPQtzBgF1I5t892weHWx0GX0jXqGqPVMowlN1Gc+ijv1T7lQm
         VXhgIJB37+a2vbPyuwlrNFXnJAeneyGY6zWeJT9wak8szDb1s91tGm2HF99IoMBaI4gZ
         vR+vZeg+I6j4EQ3GryzVPIAVSiCCuNc3pnx+A=
Date: Wed, 13 Oct 2010 16:47:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC PATCH 1/9] uaccess: Make copy_from_user_nmi() globally
	available
Message-ID: <20101013144734.GB5335@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-2-git-send-regression-fweisbec@gmail.com> <1286954156.29097.53.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286954156.29097.53.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:15:56AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> > In order to support user stack dump safely in perf samples from
> > generic code, export copy_from_user_nmi() from x86 and make it
> > generally available. For most archs it will map to
> > copy_from_user_inatomic, but for x86 we need to take care of
> > not faulting from NMIs.
> > 
> > Since perf is the first user for now, let the overriden x86
> > implementation in the perf source file.
> 
> It might make sense to call it copy_from_user_gup() because that's
> bascially what it does, it doesn't rely on NMI context anymore, its just
> NMI-safe.
> 
> Its a best effort software page table walk, and with the stacked
> kmap_atomic bits Andrew took it should work from any context.


Ok, I'll do the rename. Does that work on any arch?

Thanks.

