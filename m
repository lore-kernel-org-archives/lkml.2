Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1E3QL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:11:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37289 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab1E3QLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZdDc/IWPZIQnRZGkGbUTTnBBO5xdQG2KkqcNvSMp8+RMKqqVLFikgG39pJv8np+dK5
         c6ZZGuD7YVBylG3IFPtkRuygf3C8GoSD+hd/eTPVRK6zrzar0M8kQaKK8yK68eji0HhR
         96kdX23Hf8gRqU2Oqs63jxyuZ6OH1rzQgmGsw=
Date: Mon, 30 May 2011 18:11:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v4 0/7] perf: Introduce branch sub commands
Message-ID: <20110530161147.GA1741@somewhere>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
 <20110526132833.GC21815@nowhere>
 <4DDE7EAD.7000603@gmail.com>
 <4DE39C31.1070600@hitachi.com>
 <4DE3B724.3020203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3B724.3020203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 09:26:28AM -0600, David Ahern wrote:
> On 05/30/2011 07:31 AM, Akihiro Nagai wrote:
> >> The sample address can be converted to symbols and the output can be
> >> added to perf-script rather easily. Attached is an example. I was going
> >> to submit it back in April and got distracted. I'll rebase, move the
> >> addr->sym conversion to a function and submit later today.
> > OK.
> > I agreed with implementing it on perf script.
> > I'd like to try it.
> 
> Updated patch. It applies on top of:
>   http://lkml.org/lkml/2011/5/27/385
> 
> Hopefully for BTS you only have to change the sample_addr_correlates_sym
> function.
> 
> I still need to look into out why some of the addresses for page-faults
> are not resolving to symbols.

Perhaps it only resolves instruction faults because you only resolve with
MAP__FUNCTION. You can try MAP__VARIABLE as well when that fails.

But that is going to only help with faults on global vars, ie: only
a few part of them. Further information would require some dwarf processing.

Your patch looks good though. Mind resending it with appropriate title/changelog
and signed-off-by tag?

thanks.
