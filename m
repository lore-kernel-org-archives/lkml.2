Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1F0NxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:53:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1F0Nw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u4/dMSD3FelMrIy80uUIopktVBqU7Mi3qsICR3tXpdMEkKE4z53xkYm7FT87MaoMdx
         tZsrMKJKrEDcp/nHZEXTtXbquw6wNlTkt3TvzfCuybn1T13+/EG5vaw1vobo+ZkGVLHA
         pluo8k54yUG15piQa4ysijVRFv2nMsYmEINGI=
Date: Mon, 27 Jun 2011 15:52:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110627135252.GB30101@htj.dyndns.org>
References: <201106262108.43011.vda.linux@googlemail.com>
 <20110626200442.GA16293@redhat.com>
 <20110627081139.GY30101@htj.dyndns.org>
 <20110627134713.GB3527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627134713.GB3527@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Jun 27, 2011 at 03:47:13PM +0200, Oleg Nesterov wrote:
> > Do we want to enable this silently?  Wouldn't it be better to make it
> > dependent on PT_SEIZED?
> 
> Hmm. Not sure I understand. Why can't PTRACE_SEIZE add PT_TRACE_EXEC
> (and PT_TRACESYSGOOD) along with PT_SEIZED during attach?

I'm worrying about !PT_SEIZED case.  If we make it solely depend on
PT_TRACE_EXEC, newer kernels report the old pid while olders ones
don't and the only way to discover would be either comparing kernel
version or actually trying it - both aren't too nice.

Thanks.

-- 
tejun
