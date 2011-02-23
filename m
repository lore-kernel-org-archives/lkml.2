Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1BWXT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:19:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1BWXT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:19:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m1lj16ih0n.fsf@fess.ebiederm.org>
References: <m1lj16ih0n.fsf@fess.ebiederm.org> <20110217150257.GA26395@mail.hallyn.com> <20110217150224.GA26334@mail.hallyn.com> <3139.1298481393@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
Subject: Re: [PATCH 1/9] Add a user_namespace as creator/owner of uts_namespace
Date: Wed, 23 Feb 2011 23:19:08 +0000
Message-ID: <8559.1298503148@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> > Which means that unless the uts_namespace belongs to our user_namespace, we
> > cannot change it.  Is that correct?
> 
> No.  If you are root in a parent namespace you can also change it.

But surely, by definition, if you're a user in this namespace, you can't also
be root in a parent namespace...

For the case I worked through current_user() is a member of current_user_ns()
and can't also be a member of its parent, grandparent, etc. - or can it?

David
