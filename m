Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0EQL3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:29:39 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38148 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0EQL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BRIkotXaWiEUfyJo4/zTA4quv9BZUUsHKbpDWNBxL3cIxgKMV1gnhIxgiRpIFwkPqG
         5beKNmpb5cIjpvT4TxrBIhPK2nOdBiomqcMeqiECeeCGjwWwH+vFEBuTBB0HTUaRpT39
         lpM08XYbjic23JVTO7IINlYOXyySsBxRl8YJc=
Date: Mon, 17 May 2010 13:29:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, acme@infradead.org,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix bug mismatch with -c option definition
Message-ID: <20100517112937.GA5291@nowhere>
References: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 12:04:01PM +0200, Stephane Eranian wrote:
>   The -c option defines the user requested sampling period. It was implemented
>   using an unsigned int variable but the type of the option was OPT_LONG. Thus,
>   the option parser was overwriting memory belonging to other variables, namely
>   the mmap_pages leading to a zero page sampling buffer. The bug was exposed
>   only when compiling at -O0, probably because the compiler was padding
>   variables at higher optimization levels.
> 
>   This patch fixes this problem by declaring user_interval as u64. This also
>   avoids wrap-around issues for large period on 32-bit systems.
>  
>   Signed-off-by: Stephane Eranian <eranian@google.com>



Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Small detail: could you avoid the spaces in the beginning of
your changelog lines?

May be that's because you use git-show to dump your patches?
In which case I suggest you to use git-format-patch instead.

Thanks.

