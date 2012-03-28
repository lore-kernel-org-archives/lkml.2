Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab2C1Vhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:37:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65184 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2C1Vhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:37:41 -0400
Date: Thu, 29 Mar 2012 01:37:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120328213736.GM2204@moon>
References: <20120327223420.GB9669@moon>
 <20120327224640.GA5328@mail.hallyn.com>
 <m162dpo45j.fsf@fess.ebiederm.org>
 <20120328064838.GA2286@moon>
 <m1k425mae1.fsf@fess.ebiederm.org>
 <20120328075549.GA2204@moon>
 <20120328081639.GB2286@moon>
 <20120328194312.GA22211@mail.hallyn.com>
 <20120328194613.GA3678@redhat.com>
 <20120328213044.GA26190@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328213044.GA26190@peqn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 04:30:44PM -0500, Serge Hallyn wrote:
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 03/28, Serge E. Hallyn wrote:
> > >
> > > If you want to
> > > just add the struct cred to the f_owner and do proper uid conversion,
> > > I'll support that too.  (Just grab a ref to the cred in
> > > fs/fcntl.c:f_modown(), and drop the ref in fs/file_table.c:__fput() ).
> > 
> > In this case f_owner.*uid should go away, I guess.
> 
> Yup.
> 
> Which I guess is all the more reason *not* to do this unless we end up
> not going with Eric's userns mapping patchset (which is unlikely).
> 
> > And sigio_perm()
> > should be unified with kill_ok_by_cred() somehow (modulo
> > security_file_send_sigiotask).
> > 
> > Right?
> 
> Maybe, but other differences include current being the signal sender in
> one and recipient in the other, and CAP_KILL being relevent in only
> one.

Hi Serge, thanks a lot for comments! Replying to prev email --
I've skipped cred part intentionally, I guess we need to wait
until Eric's patches hit LKML (if I understand all right) then
I'll expand the patch. I'll think a bit more tomorrow, ok?

	Cyrill
