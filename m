Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2C1Txx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501Ab2C1Txw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:53:52 -0400
Date: Wed, 28 Mar 2012 21:46:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120328194613.GA3678@redhat.com>
References: <20120327165853.GH11875@moon> <20120327222923.GA31692@mail.hallyn.com> <20120327223420.GB9669@moon> <20120327224640.GA5328@mail.hallyn.com> <m162dpo45j.fsf@fess.ebiederm.org> <20120328064838.GA2286@moon> <m1k425mae1.fsf@fess.ebiederm.org> <20120328075549.GA2204@moon> <20120328081639.GB2286@moon> <20120328194312.GA22211@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328194312.GA22211@mail.hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Serge E. Hallyn wrote:
>
> If you want to
> just add the struct cred to the f_owner and do proper uid conversion,
> I'll support that too.  (Just grab a ref to the cred in
> fs/fcntl.c:f_modown(), and drop the ref in fs/file_table.c:__fput() ).

In this case f_owner.*uid should go away, I guess. And sigio_perm()
should be unified with kill_ok_by_cred() somehow (modulo
security_file_send_sigiotask).

Right?

Oleg.

