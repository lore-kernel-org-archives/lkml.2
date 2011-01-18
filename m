Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1ARPwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:52:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40057 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1ARPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RiDxYV75nWVyjmIc8uAAlUYe30Q0u3Rda3UFbDsiSaOhZVhMcenpbDNfSaIv7tAdCC
         ACzBXhRVFvcbwFz/2mbnwIk2Ji4F5j1Wg8L43Ogy0vwHo2o+SKgF9GNN3rfiDehwPUTH
         wdXoRxYsQpBuhQfZxQbYDQaIvHxO+V7pPa7q8=
Date: Tue, 18 Jan 2011 16:52:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: remove superfluous sub instructions
Message-ID: <20110118155159.GA1791@nowhere>
References: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 04:28:18PM +0100, Jiri Olsa wrote:
> hi,
> 
> I think there's no need for substracting MCOUNT_INSN_SIZE from the
> IP parameter before calling the function trace (/graph) handler.
> 
> Maybe I overlooked something, but all the IP usage I saw ended
> up in the kallsyms_lookup function, which does the lookup using the
> functions' start/end boundaries to find the correct symbol for pointer.
> 
> Thus it seems to me there's no point in substracting the
> MCOUNT_INSN_SIZE value from the IP parameter.
> 
> I tested for x86_64 and got proper results, I believe it's
> the same case for x86_32.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Well, that sounds right after all. If we are only interested in the
symbol, the instruction that follows "call mcount" is still relevant
as it must belong to the same function.

Steve?
