Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0EDOxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab0EDOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:53:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100427164245.GA7530@us.ibm.com>
References: <20100427164245.GA7530@us.ibm.com> <20100427164139.GA7359@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 1/3] p9auth: split core function out of some set*{u,g}id functions
Date: Tue, 04 May 2010 15:52:19 +0100
Message-ID: <3976.1272984739@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> Break the core functionality of set{fs,res}{u,g}id into cred_setX
> which performs the access checks based on current_cred(), but performs
> the requested change on a passed-in cred.
> 
> Export the helpers, since p9auth can be compiled as a module.  It
> might be worth not allowing modular p9auth to avoid having to export
> them.
> 
> Really the setfs{u,g}id helper isn't needed, but move it as
> well to keep the code consistent.
> 
> This patch also changes set_user() to use new->user->user_ns.  While
> technically not needed as all callers should have new->user->user_ns
> equal to current_userns(), it is more correct and may prevent surprises
> in the future.
> 
> Changelog:
> 	Apr 24: (David Howells) make cred_setresuid etc extern, and
> 		document the helpers in Documentation/credentials.txt.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
