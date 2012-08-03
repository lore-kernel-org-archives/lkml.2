Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2HCMwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:52:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2HCMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:52:21 -0400
Date: Fri, 3 Aug 2012 13:52:10 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID
 namespace
Message-ID: <20120803125210.GD12870@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
 <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 05:45:40AM -0700, Eric W. Biederman wrote:
> The solution is to use user namespaces and to only test ns_capable on the magic reboot path.
> 
> For the 3.7 timeframe that should be a realistic solution.

Hmm, that would imply that if LXC wants to allow reboot()/CAP_SYS_BOOT
they will be forced to use CLONE_NEWUSER. I was rather looking for a way
to allow the container to keep CAP_SYS_BOOT, without also mandating use
of user namespaces.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
