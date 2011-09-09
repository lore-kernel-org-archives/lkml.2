Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab1IIQ3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab1IIQ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:29:32 -0400
Date: Fri, 9 Sep 2011 18:26:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110909162606.GC23271@redhat.com>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <20110909001853.GA29319@htj.dyndns.org> <201109090754.50272.vda.linux@googlemail.com> <93a9bd6624aa6a991d688bfaba766a91.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a9bd6624aa6a991d688bfaba766a91.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Indan Zupancic wrote:
>
> It is very useful to set options atomically at SEIZE time.

Nobody argues with this.

> Another important reason to make PTRACE_O_TRACESTOP an option is
> because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
> set this option at all.

Yes. This was already discussed, PTRACE_TRACEME obviously doesn't
work if you need the new features. So far it was decided TRACEME
should be avoided, but perhaps we can add SEIZE_ME. And, unlike
TRACEME it should probably stop immediately to simplify the
synchronization with parent. Afaik, any user of TRACEME does
something like kill(getpid(), SIGSTOP), this doesn't look very
good.

But personally I'd prefer to avoid SEIZE_ME.

Oleg.

