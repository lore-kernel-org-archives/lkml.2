Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1BNPTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:19:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39770 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab1BNPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mptHtaFTS//eOp4DwWCSgzgv87JlfFMPhKx/kgTnC5k0cNZOyMCZpiyLe3/WM5ocm7
         p2bMV0jAPCLF8JFoKa9hLeT68KifY4bRLDXues7OtN7FP31oYhb3zGx9lW9SZhLNoHVI
         BDOiBs1abrdm2bicOEEyloHCEbGuQppjxe1QU=
Date: Mon, 14 Feb 2011 16:19:28 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214151928.GQ18742@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110204130455.GA3671@redhat.com>
 <20110204144858.GI12133@htj.dyndns.org>
 <201102132224.25197.vda.linux@googlemail.com>
 <20110214150656.GA8761@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214150656.GA8761@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 04:06:56PM +0100, Oleg Nesterov wrote:
> This was (very briefly) discussed recently. Probably we can implement
> PTRACE_DETACH_RUNNING (the name is random) which doesn't require the
> stopped tracee but ignores the "data" argument.

I think the root problem is not how ptrace detaches but how ptrace
attaches and stops tracee.  If we have a clean way to seize the
tracee, how we detach doesn't really matter.  For example, a new
ptrace call which stops the tracee and puts it in a ptrace command
ready state without messing with the signal and group stop stuff.

Thanks.

-- 
tejun
