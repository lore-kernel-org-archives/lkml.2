Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1KJBl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:41:26 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47029 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1KJBlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:41:24 -0500
Date: Wed, 9 Nov 2011 17:41:14 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        containers@lists.linux-foundation.org, oleg@redhat.com,
        eparis@redhat.com, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 1/6] user namespace: make signal.c respect user
 namespaces (v4)
Message-ID: <20111110014114.GB26567@count0.beaverton.ibm.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
 <1320445482-8459-2-git-send-email-serge@hallyn.com>
 <20111108162216.1ffb3e9a.akpm@linux-foundation.org>
 <20111109141853.GB4010@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109141853.GB4010@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11111001-8974-0000-0000-000001C06226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:18:53AM -0600, Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Fri,  4 Nov 2011 22:24:37 +0000
> > Serge Hallyn <serge@hallyn.com> wrote:
> > 
> > > +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)

nit: Seems like the function name itself needs a fixup. I can imagine a
user-ns-unaware kernel developer thinking this when they see code calling
this function:

<naive>
Gosh, why is the uid broken? I have no idea what this does or when it
would be needed. Why hasn't it been splatted all over the kernel? Who broke
it?
</naive>

You can't even tell from the name that it's for user namespaces.

Cheers,
	-Matt

