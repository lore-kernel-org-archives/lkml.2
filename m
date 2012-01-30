Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2A3V7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:59:21 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38846 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab2A3V7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:59:19 -0500
X-Sasl-enc: WF2+NvEmJOKvpYjS3Jhdy3v3tk0Q5770eqQuaNk3PUFF 1327960758
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
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
Date: Mon, 30 Jan 2012 16:58:54 -0500
In-Reply-To: <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
	 <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327960736.5355.5.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
> Chroot can easily be used to subvert setuid programs.  If no_new_privs,
> then setuid programs don't gain any privilege, so allow chroot.

Is this needed/desired by anyone now, or are you just using it to "demo"
NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
"container"-type chroot you really want /proc and /dev, and your patch
doesn't help with that.

System daemons that do chroot for a modicum of security already start
privileged, so this doesn't help them either.



