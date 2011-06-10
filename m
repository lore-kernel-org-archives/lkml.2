Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1FJUgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:36:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51393 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJUgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=roD5CuEjKwO7FVNwR4Stb77jApfi6BWMBAQasqSH2qbGEOFyHuT6GxCIgp7Y99cWLt
         s413UD9Df496VKcBYp/W7eDAg8ZJ9SCDIqOQIfeMqdTbXH2BXoqWeAsix1xHB7szFYso
         VOKMKxfREbP7aFMFSClqnYLaU0VU7Atdsca2Y=
MIME-Version: 1.0
In-Reply-To: <4DF1D0DC.8060806@jp.fujitsu.com>
References: <4df13c722729547622@agluck-desktop.sc.intel.com>
	<4DF1D0DC.8060806@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 13:36:01 -0700
X-Google-Sender-Auth: qhJjs3bo28HIYV52aRsgudE6qU0
Message-ID: <BANLkTinLtZ-ZtQRFWW0PPOFvxYpuqncyig@mail.gmail.com>
Subject: Re: [PATCH 06/10] HWPOISON: Handle hwpoison in current process
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> It doesn't make sense that the function named "*_ao" sends _AR.

Oops. Good point.

> I suppose that usually SRAO is handled in worker thread scheduled after
> MCE, so current is unlikely one of affected threads in that case...
> And I also suppose that you'd like to use this function to be called
> from affected thread before leaving kernel in the case of SRAR...
>
> My concern is that "t == current" is neither strong nor clear statement
> to switch the type of signal.  Someone might want to use this function
> to inject _AO to current.
>
> It is better to have new kill_proc_ar() (separated, or one shared _common
> plus a couple of _ar/_ao), I think.  I believe that there is no caller
> who have no idea whether it should request sending _AR or _AO.

Agreed - each call chain should know whether it is AR or AO. I think
there is plenty of room to make this code cleaner and clearer.

In the AR case we will always be in the current task context - and we
know that we cannot let the process ignore the signal.

In the AO case we will usually be in some other task context (except
by random chance) - and we shouldn't mind if the signal is currently
blocked, or ignored.

-Tony
