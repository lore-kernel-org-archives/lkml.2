Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2APUtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:49:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50858 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767Ab2APUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:49:29 -0500
X-Sasl-enc: dmskoLdi2gNOA7BTBWowUztMya7RFDGqPDlf9nP+r0C5 1326746969
Subject: Re: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 16 Jan 2012 15:49:07 -0500
In-Reply-To: <cover.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326746949.3467.16.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 16:37 -0800, Andy Lutomirski wrote:
> To make the no_new_privs discussion more concrete, here is an updated
> series that is actually useful.  It adds PR_SET_NO_NEW_PRIVS

I think it'd be clearer to call it PR_SET_NOSUID - basically it should
match the semantics for MS_NOSUID mounts, as if on every exec()
thereafter the target binary was on a nosuid filesystem.

You might then change this flag to only take effect on a later exec(),
which would solve your race condition for the hypothetical PAM module.

>  with the
> same semantics as before (plus John Johansen's AppArmor fix and with
> improved bisectability).  It then allows some unshare flags 

What's the rationale behind the unshare subset?  Did you actually
analyze any setuid binaries found on Debian/Fedora etc. and determined
that e.g. CLONE_NEWNET was problematic for some reason?

I actually want CLONE_NEWNET for my build tool, so I can be sure the
arbitrary code I'm executing as part of the build at least isn't
downloading more new code.


