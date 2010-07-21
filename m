Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0GUPqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:46:15 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59165 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0GUPqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YquDGvZqttuFae0b7JGS0RIjK6LOBfudCxmm7xRVW7RjeigmCGdXilXQMZ4RyHfd+a
         4jCcM+o7cNuroeDnmqnozatzRbGNFbbFlyqQDLkK/cbwwUXKc57QfSIuqI1QLTk+9HMv
         35C5kgQOlxRFsMlXvOOGpGlbjLITH3Z1wZkNE=
MIME-Version: 1.0
In-Reply-To: <1279658102-20069-5-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
	<1279658102-20069-5-git-send-email-tj@kernel.org>
Date: Wed, 21 Jul 2010 10:46:11 -0500
Message-ID: <AANLkTilSR15Cmz-dTyIDvOl-qdYrQ6x84BY7f9LggElW@mail.gmail.com>
Subject: Re: [PATCH 4/7] cifs: use workqueue instead of slow-work
From: Steve French <smfrench@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 3:34 PM, Tejun Heo <tj@kernel.org> wrote:
> Workqueue can now handle high concurrency.  Use system_nrt_wq
> instead of slow-work.
>
> * Updated is_valid_oplock_break() to not call cifs_oplock_break_put()
>  as advised by Steve French.  It might cause deadlock.  Instead,
>  reference is increased after queueing succeeded and
>  cifs_oplock_break() briefly grabs GlobalSMBSeslock before putting
>  the cfile to make sure it doesn't put before the matching get is
>  finished.
>
> * Anton Blanchard reported that cifs conversion was using now gone
>  system_single_wq.  Use system_nrt_wq which provides non-reentrance
>  guarantee which is enough and much better.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Anton Blanchard <anton@samba.org>
> ---
>  fs/cifs/Kconfig    |    1 -
>  fs/cifs/cifsfs.c   |    5 -----
>  fs/cifs/cifsglob.h |    8 +++++---
>  fs/cifs/dir.c      |    2 +-
>  fs/cifs/file.c     |   30 +++++++++++++-----------------
>  fs/cifs/misc.c     |   20 ++++++++++++--------
>  6 files changed, 31 insertions(+), 35 deletions(-)

Acked-by: Steve French <sfrench@us.ibm.com>



-- 
Thanks,

Steve
