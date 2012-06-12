Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2FLN3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:29:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45958 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2FLN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:29:53 -0400
Message-ID: <4FD74447.2090906@redhat.com>
Date: Tue, 12 Jun 2012 15:29:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 3/3] deal with guest panicked event
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FB9E5CB.2020208@cn.fujitsu.com>
In-Reply-To: <4FB9E5CB.2020208@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/05/2012 08:50, Wen Congyang ha scritto:
> +DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
> +    "-onpanic report|pause|quit\n" \
> +    "                action when the guest is panicked [default=report]",
> +    QEMU_ARCH_ALL)
> +STEXI
> +@item -onpanic @var{action}
> +
> +The @var{action} controls what QEmu will do when the guest is panicked.
> +The default is @code{report} (emit QEVENT_GUEST_PANICKED only).

-watchdog-action just calls this "none".

> +Other possible actions are:
> +@code{pause} (emit QEVENT_GUEST_PANICKED and pause VM),
> +@code{quit} (emit QEVENT_GUEST_PANICKED and quit VM).

Rather than just "quit", there should be choices for "shutdown",
"poweroff" and "reset" for consistency with -watchdog-action.

Also, this option should also be accessible from "-machine", please.

Paolo

> +ETEXI
> +
>  HXCOMM This is the last statement. Insert new options before this line!
>  STEXI
>  @end table
