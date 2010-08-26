Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0HZMfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:35:16 -0400
Received: from lo.gmane.org ([80.91.229.12]:46788 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0HZMfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:35:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] V4L/DVB: mantis: Fix IR_CORE dependency
Date: Thu, 26 Aug 2010 14:34:55 +0200
Organization: m
Message-ID: <87aao9y2kw.fsf@nemi.mork.no>
References: <4C643A08.3000605@redhat.com> <20100824084528.GA26618@elte.hu>
	<4C73E46B.8050203@oracle.com> <20100824193039.GA20425@elte.hu>
	<4C743D2E.7090803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 193.160.199.2
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:EtsOOOe3ujoP9DGxwnvQD8p9pTs=
Cc: linux-media@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder, am I really the only one who find it somewhat strange that
it's necessary to break the mantis driver by doing changes to code which
is not used at all?  Yes, mantis_input.c may be linked into mantis_core,
so it is capable of breaking the build, but there is *nothing* calling
the code.

IMHO mantis_input.c should be removed unless it can be fixed up enough
to be enabled, but one would have to know why it was disabled in the
first place to do that.  Dead code can always be ressurrected later if
someone is willing to work on it.  This completely unnecessary
dependency bug gives you at least one good reason why keeping dead code
is bad.

(Keeping the code might have been considered if it was likely to be used
in the near future, but this is not the case given that you do not
currently accept any patches actually improving the mantis driver.)

It's not that this bug is so bad or nothing.  I'm just puzzled by your
development priorities, which is the direct cause of this bug.

Let me know if you are going to start accepting patches for the mantis
driver (the best way is by doing something with the patches already
posted), and I will prepare and test a patch removing mantis_input.c

Just my €0.02


Bjørn

