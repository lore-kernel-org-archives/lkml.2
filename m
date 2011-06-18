Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1FRH7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 03:59:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50994 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1FRH7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 03:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AXV5oa62vVSarQzAxQi6HI9LONNLD8u/j7B9cJsuUC467t7stYz6zKSZK/CnrvsUSJ
         hPIBB78vARG/ZSkVhXGGSg+Truy2u9BZPYznRwjaxtQqWH28/AofgUYqS3BUUNn3BGwU
         TEYnImAmYBRHfi8738jNLg9FNKkhAuiUON0/E=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Date: Sat, 18 Jun 2011 09:59:38 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <1308043218-23619-3-git-send-email-tj@kernel.org> <201106180955.37531.vda.linux@googlemail.com>
In-Reply-To: <201106180955.37531.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106180959.38847.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 09:55, Denys Vlasenko wrote:
> On Tuesday 14 June 2011 11:20, Tejun Heo wrote:
>    #define PTRACE_EVENT_FORK    1
>    #define PTRACE_EVENT_VFORK   2
>    #define PTRACE_EVENT_CLONE   3
> >  #define PTRACE_EVENT_EXEC	4
> >  #define PTRACE_EVENT_VFORK_DONE	5
> >  #define PTRACE_EVENT_EXIT	6
> > +#define PTRACE_EVENT_STOP	7
> 
> Er... these constants were corresponding exactly to
> bit positions in ptrace options which enable them:
> 
> #define PTRACE_O_TRACESYSGOOD   0x00000001
> #define PTRACE_O_TRACEFORK      0x00000002
> #define PTRACE_O_TRACEVFORK     0x00000004
> #define PTRACE_O_TRACECLONE     0x00000008
> #define PTRACE_O_TRACEEXEC      0x00000010
> #define PTRACE_O_TRACEVFORKDONE 0x00000020
> #define PTRACE_O_TRACEEXIT      0x00000040
> 
> For example, PTRACE_O_TRACEEXEC is 4th bit, PTRACE_EVENT_EXEC is 4.
> 
> If we'd define PTRACE_EVENT_STOP as 7, any future added
> PTRACE_O_foo bit with value 0x00000080 will be unable
> to follow this convention.
> 
> I propose to define PTRACE_EVENT_STOP as 64 instead, leaving 64 low
> PTRACE_EVENT_foo constants for possible future PTRACE_O_foo bits.
> 
> [32 should be enough too, but I feel paranoid today :)]

...unless we plan to introduce PTRACE_O_TRACESTOP (with value 0x00000080)
which enables PTRACE_INTERRUPT and stop notifications independently
of PTRACE_SEIZE. Which would be very useful for e.g. strace.

Then, PTRACE_EVENT_STOP indeed should be 7.

-- 
vda

