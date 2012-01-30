Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2A3WSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:18:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2A3WSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:18:09 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=dckYjZd89k8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=u_0EbvZYnO6A1ro0pycA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327961884.5882.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Colin Walters <walters@verbum.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Date: Mon, 30 Jan 2012 17:18:04 -0500
In-Reply-To: <1327960736.5355.5.camel@lenny>
References: <cover.1327858005.git.luto@amacapital.net>
	 <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
	 <1327960736.5355.5.camel@lenny>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 16:58 -0500, Colin Walters wrote:
> On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
> > Chroot can easily be used to subvert setuid programs.  If no_new_privs,
> > then setuid programs don't gain any privilege, so allow chroot.
> 
> Is this needed/desired by anyone now, or are you just using it to "demo"
> NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
> "container"-type chroot you really want /proc and /dev, and your patch
> doesn't help with that.
> 
> System daemons that do chroot for a modicum of security already start
> privileged, so this doesn't help them either.

I thought this was all for sandboxing? If a browers (or user) wants to
run some untrusted code, perhaps a chroot is the best way to do so. It
just will break if it needs to access /proc or /dev. And perhaps we
don't want untrusted code accessing /proc and /dev.

-- Steve



