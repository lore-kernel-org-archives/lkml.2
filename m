Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab1DZHnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:43:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36851 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab1DZHns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qt5fKoyO/7eMOMtpHFFwn8zzidQ+xb5MgJAIjIREg39EJwQAwoi608b1yvaNaG5r8N
         OIFqtxlkmsIpQxqFbpUxvHr6YTlVQ86n/2teRigJmDA42gKJ1uqjph0oh/zDTYfXEICv
         nK3VCZzZ88yWyCjzHHHpp+ct2K+xHxMXJsRhk=
MIME-Version: 1.0
In-Reply-To: <1303803525.20212.20.camel@twins>
References: <1303747731.2747.182.camel@edumazet-laptop>
	<1303803525.20212.20.camel@twins>
Date: Tue, 26 Apr 2011 10:43:47 +0300
X-Google-Sender-Auth: dO4IFEUYwhxRyoENswLUuJpWcLs
Message-ID: <BANLkTikTq+V28wi_zujeJK+OksDTdjiUcg@mail.gmail.com>
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:38 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-04-25 at 18:08 +0200, Eric Dumazet wrote:
>> Hi guys
>>
>> Just got a panic on a kmemcheck kernel, latest linux-2.6 tree.
>>
>> I forgot I had kmemcheck enabled, and started "perf top" just because my
>> machine was damn slow... Oh well...
>>
>> Crash in do_nmi -> nmi_enter() -> BUG_ON(in_nmi());
>
> Hmm,. I bet because kmemcheck triggers faults from nmi context because
> it messes about with the page protection bits a lot to track things.
>
> Can't really think of anything except not making perf available on
> kmemcheck kernels.
>
> ---
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 32745bf..94735b4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1125,6 +1125,7 @@ config PERF_EVENTS
>        bool "Kernel performance events and counters"
>        default y if (PROFILING || PERF_COUNTERS)
>        depends on HAVE_PERF_EVENTS
> +       depends on !KMEMCHECK
>        select ANON_INODES
>        select IRQ_WORK
>        help

Acked-by: Pekka Enberg <penberg@kernel.org>
