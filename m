Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1EXMAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:00:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60573 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1EXMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aQSEeAJWsTdS9oZ9SaEgG378Bkz4Qwkxgt8LLp8jQnYAprq/pZ8NFUv7xWZGIRQ1Jd
         cK0xp2MGhpehrZedCo5ufVoVwLxTOzjogV0gRykGdy0xaChS4szTXTL02jgXAWia9U8d
         E6tu6ro2blFa4mhB+GeZiQYwKV3ZCzr7jdZEs=
Date: Tue, 24 May 2011 14:00:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110524120013.GD10334@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105201027.36688.pedro@codesourcery.com>
 <20110520093111.GG31426@htj.dyndns.org>
 <201105241049.58921.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105241049.58921.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 24, 2011 at 10:49:58AM +0100, Pedro Alves wrote:
> A couple interface questions that just crossed my mind:
> 
>  - on a fork/vfork/clone, if PTRACE_EVENT_FORK|VFORK|CLONE have been
>    enabled, will the tracer still see the new child stop with a
>    SIGSTOP, or will it see a PTRACE_EVENT_INTERRUPT?

This won't change, so SIGSTOP although we probably want to improve it
such that this can be distinguished from SIGTRAP from userland.

>  - is PTRACE_INTERRUPT on PTRACE_TRACEME-traced-child planed to
>    be allowed (for convenience)?
>    A PTRACE_O_TRACEINTERRUPT, or some such PTRACE_SETOPTIONS
>    option might be necessary to get PTRACE_EVENT_INTERRUPT instead
>    of SIGSTOP in the point above.

I'm currently leaning toward deprecating PTRACE_TRACEME.  If a task
can PTRACE_TRACEME, it may as well just do pause(2) and let the parent
SEIZE it.

Thanks.

-- 
tejun
