Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0H0M6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:58:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0H0M6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=PnvFrbxrGoeVHfKbL34MZI2RbfOIugDCS0Z2a9dmOok/JWT5QKqBcm5iWAzPRfeVNQ
         eB64ULxPk7Cf/HtTrWAW1RQCV4reMPMSnj7LS8WtInf71RnzPCeOHKlyLxlM0fKtTAWC
         cAHqYHBV5E2z6+93OtaXokY9YkRYZwQlbFHZg=
From: Namhyung Kim <namhyung@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
References: <87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
	<1282902149-12991-15-git-send-email-namhyung@gmail.com>
	<1282902149-12991-1-git-send-email-namhyung@gmail.com>
	<4072.1282906906@redhat.com> <5542.1282911123@redhat.com>
Date: Fri, 27 Aug 2010 21:58:26 +0900
In-Reply-To: <5542.1282911123@redhat.com> (David Howells's message of "Fri, 27
	Aug 2010 13:12:03 +0100")
Message-ID: <8762ywgqkt.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Namhyung Kim <namhyung@gmail.com> wrote:
>> I just wanted to let you know it depends on that.
>
> The patch being part of the series is probably sufficient, though a note of
> the subject line of the previous patch would be useful.
>

I see. Will do that hereafter.


>> What is the proper way to handle this?
>
> A summary of the changes being made is good:
>
> 	ptrace: Fix up the arguments arch_ptrace() in arch FRV
>
> 	Fix up the arguments to arch_ptrace() to take account of the fact that
> 	addr and data are now unsigned long rather than long as of a preceding
> 	patch in this series.
>
> 	Signed-off-by: ...
>

Thanks. I will use this on the next round. :-)


> Note, however, that if the earlier patch breaks the compilation and then this
> patch fixes it up, you should roll this patch into the earlier patch, and the
> earlier patch is not complete without it.
>
> Think what happens if patch 3/43 breaks an arch, and then patch 43/43, say,
> mends that arch, and then bisection lands on patch 3 during its progress.  You
> may end up having to 'git bisect skip' all the patches between 3 and 43 one at
> a time.
>

In this series, 3/43 changes the prototype of arch_ptrace() in
include/linux/ptrace.h and the following patches change it for each arch in
arch/xxx/kernel/ptrace.c. Do you mean all of arch change patches should be
combinded into a patch?

-- 
Regards,
Namhyung Kim
