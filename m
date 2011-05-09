Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1EIKJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:09:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48058 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1EIKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/RhitBYuVGmY/KrLXitL396sr7mbzYsDCeMXfpxVkN+vtiKJObNMfWL3TVnnSDsvG
         cvM3BOgvLoctmhSJwmtD3Cf68wJey/grIJYl7/0cavyAB7r7kC2sHC7qKxi9wQcLnEhK
         fuq3nqv7SV7OtNGlYwJ7Hi3AdjvOCC3nkkvvY=
Date: Mon, 9 May 2011 12:09:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110509100931.GH1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org>
 <201105082358.20159.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105082358.20159.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 08, 2011 at 11:58:20PM +0200, Denys Vlasenko wrote:
> Are rules for PTRACE_INTERRUPT the same? That is, what happens
> if a different trap is taken?

Oh, PTRACE_INTERRUPT is different.  If it's scheduled, it will
eventually happen.  Other traps may happen before but INTERRUPT trap
will take place before control is returned to userland.

> Can you add API notes in the header, above corresponding defines? -
> 
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -48,6 +48,7 @@
>  #define PTRACE_SETREGSET       0x4205
>  
> <============================================ ADD COMMENT HERE
>  #define PTRACE_SEIZE           0x4206
> <============================================ ADD COMMENT HERE
> +#define PTRACE_INTERRUPT       0x4207
> 
> 
> They will be much more visible and up-to-date there than in Documentation,
> git logs etc...

Hmmm... I was thinking about writing a proper ptrace API doc with
example programs under Documentation/.  It's userland visible API so
it shouldn't change all that much and the amount of necessary
documentation would be too much for comments.

Thank you.

-- 
tejun
