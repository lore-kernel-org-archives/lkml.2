Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2HFTTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:19:30 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:54772 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2HFTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:19:29 -0400
Date: Mon, 6 Aug 2012 19:20:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID
 namespace
Message-ID: <20120806192040.GA27023@mail.hallyn.com>
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
 <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com>
 <20120803125210.GD12870@redhat.com>
 <bef31b2b-429b-4b2b-981b-b230f9c6bfad@email.android.com>
 <1344122135.1422.2.camel@Nokia-N900-51-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344122135.1422.2.camel@Nokia-N900-51-1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge Hallyn (serge@hallyn.com):
> Eric,
> 
> during the container reboot discussion, the agreement was reached that rebooting for real fron non-init pid ns is not safe.  Restarting userspace (in pidns caller owns) is.  I argue the same reasoning supports this.
> 
> I haven't had a chance to review the patch, but the idea gets my ack.  I'll look at the patch asap.
> 
> I'm also fine with splitting cap_sys_boot into a user and system caps.  The former would only be needed targeted to the userns of the init pid, while the latter would be required to init_user_ns.  Then containers could safely be given cap_sys_restart or whatever, but not cap_sys_boot which authorizes kexec and machine reset/poweroff.

Splitting the cap up into CAP_RESTART (restart /sbin/init) and CAP_BOOT
(reboot hardware or kexec kernel) has the advantage that the capabilities
each remain simpler to parse, no 'in this context it means that'.
