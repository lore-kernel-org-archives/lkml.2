Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1FRIak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:30:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1FRIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ocO5i3NbiD5y9225Nn3ErCQrU/e7yCIHllNVQmH9E4kgCT+Na+PsiBklN3myIBA7x2
         DkUNnTxl0/dMNMFM8y1aEndf4VGfrNzc0K8KpQpmRM1+Dv+ZcBQZD+Xj5baUtTagAji5
         4hpGvGy5q+FbglMMo4L4eknFcfNu821BGDgcI=
Date: Sat, 18 Jun 2011 10:30:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Message-ID: <20110618083032.GJ2611@htj.dyndns.org>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
 <1308043218-23619-3-git-send-email-tj@kernel.org>
 <201106180955.37531.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106180955.37531.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jun 18, 2011 at 09:55:37AM +0200, Denys Vlasenko wrote:
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

I'm not sure how this will actually play out but currently planning on
adding more implicitly enabled events on SEIZE.

> I propose to define PTRACE_EVENT_STOP as 64 instead, leaving 64 low
> PTRACE_EVENT_foo constants for possible future PTRACE_O_foo bits.
> 
> [32 should be enough too, but I feel paranoid today :)]

But this might not be a bad idea.  Given that we also support 32bit
archs, going over 32 wouldn't help much tho.

Thanks.

-- 
tejun
