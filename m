Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1FUHVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62711 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1FUHVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eNCXv0HYVy9kGt9IMPhMIRjQj/ErVOL7rVvOeqkWNOXXJSm0l+KyWA7Fs6Cymk5JsA
         DU/JAvNgJINT/2iyBL9qJt40ilfyag/LLgVwbWzyhQUisO5TFvBFfizrtsBOnClSwqpX
         buKp89NS1hJJZnq/Vz2fbsCnHIBXk1vNwc1LY=
MIME-Version: 1.0
In-Reply-To: <20110620202504.GB17157@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
	<1308322240-8247-4-git-send-email-tj@kernel.org>
	<20110620202504.GB17157@redhat.com>
Date: Tue, 21 Jun 2011 09:21:13 +0200
X-Google-Sender-Auth: VtsTQ0lSbemApjAjT6NY37Vo6ig
Message-ID: <BANLkTimuRogA6St5GP0sRd1CY5u=jBABBg@mail.gmail.com>
Subject: Re: [PATCH 3/7] ptrace: move SIGTRAP on exec(2) logic to ptrace_event()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 20, 2011 at 10:25 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Why does this make ptrace_event() smarter?
>
> OK, tracehooks should die. But why should we move this special case
> into ptrace_event? Say, a simple
>
>        static inline void ptrace_exec_event(...)
>        {
>                if (!ptrace_event_enabled(PTRACE_EVENT_EXEC))
>                        send_sig(SIGTRAP, current, 0);
>                else
>                        ptrace_event(PTRACE_EVENT_EXEC);
>        }
>
> in fs/exec.c looks a bit better to me.

The intention is to concentrate ptrace specific logic in
ptrace_event().  We'll have more of them, mostly dependent on
PT_SEIZED and I don't think it's a good idea to scatter them across
the kernel.  They're of no interest outside of ptrace after all.  I
think it's better to have them collected in one place than scattered
around.  The PT_SEIZED ones would probably have some commonalities
among them too.

Thanks.

-- 
tejun
