Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1GVPCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1GVPCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:02:00 -0400
Date: Fri, 22 Jul 2011 16:59:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Merging ptrace branch into mainline
Message-ID: <20110722145934.GB7408@redhat.com>
References: <20110722103059.GK2622@htj.dyndns.org> <CAK1hOcPPyu7Q_o9JAj8VnGkhUShFFc+T1aYsKmhGhho2ykOD6Q@mail.gmail.com> <20110722133907.GL2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722133907.GL2622@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Tejun Heo wrote:
>
> Single step and breakpoints use SIGTRAP and there are some variances
> on the information being reported depending on archs and IIRC it isn't
> always possible to discern those debug traps from kill(SIGTRAP)'s from
> userland.

Yes, we should audit the arch/ code.

On x86 the tracer can discern step/breakpoints traps afaics, still probably
it makes sense to change do_int3() to use fill_sigtrap_info(). Currently we
report si_code = SI_KERNEL.

Oleg.

