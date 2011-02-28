Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1B1Q5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1B1Q5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:57:15 -0500
Date: Mon, 28 Feb 2011 17:48:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110228164814.GA8538@redhat.com>
References: <20110224202941.GA12258@redhat.com> <20110225155142.GQ24828@htj.dyndns.org> <201102260348.03312.vda.linux@googlemail.com> <20110228125622.GA9326@htj.dyndns.org> <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com> <20110228132941.GB9326@htj.dyndns.org> <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com> <20110228135312.GC9326@htj.dyndns.org> <AANLkTimQV0j2MuPdwQBgpdCN6nA9KTbVwrSM1Ut0i_=q@mail.gmail.com> <20110228143920.GD9326@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228143920.GD9326@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Tejun Heo wrote:
>
> I believe this is already solved by making the tracee always enter
> TASK_TRACED via ptrace_stop() on attach, which always reports the
> group stop signal to the ptracer whether the real parent has consumed
> it or not.  The patch is at the top of this gigantic thread.  Oleg,
> this is solved one, right?

Yes, sure. gdb will never see the stopped (I mean task->state) tracee
after attach, so it does not need to do something special. This problem
with exit_code == 0 is fixed too.

Oleg.

