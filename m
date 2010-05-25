Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0EYTMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab0EYTMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:12:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Uclinux-dist-devel] [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix 
	the unsafe usage of child->mm
In-Reply-To: Mike Frysinger's message of  Monday, 24 May 2010 21:29:34 -0400 <AANLkTinpMp1yZ2c5B5O7aT2NR57zBHlggvUXZ58bLGv2@mail.gmail.com>
References: <20100522165401.GB19573@redhat.com>
	<1266280229-18469-1-git-send-email-vapier@gentoo.org>
	<1274431345-22366-1-git-send-email-vapier@gentoo.org>
	<20100521162659.GA16193@redhat.com>
	<20100521183512.4477F40476@magilla.sf.frob.com>
	<20100522165320.GA19573@redhat.com>
	<25539.1274711817@redhat.com>
	<20100524151445.GA6393@redhat.com>
	<20100524234250.F158849A56@magilla.sf.frob.com>
	<AANLkTinpMp1yZ2c5B5O7aT2NR57zBHlggvUXZ58bLGv2@mail.gmail.com>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20100525191146.E70E549A54@magilla.sf.frob.com>
Date: Tue, 25 May 2010 12:11:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> are you suggesting the FDPIC additions are ill-advised as well ?
> curious how you would have implemented this if that's the case ...

They are certainly not as dismal as the arch PTRACE_PEEKUSR delivering
mm->fields.  But, frankly I don't think ptrace is the right mechanism for
delivering any read-only, process-shared information.  You can use some
/proc/pid/foo for that.  (The "dismal" cases deliver things like
start_code, which is already available in /proc/pid/stat.)


Thanks,
Roland
