Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2KHPEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:04:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58954 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2KHPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAMR49Lp07mn3dOhaN9LpckCHVY7vMBc2SRvp4JqX3cYTtcG=nQ@mail.gmail.com>
References: <1352189869-27190-1-git-send-email-jarkko.sakkinen@iki.fi>
	<50998834.5030407@schaufler-ca.com>
	<CAMR49Lp07mn3dOhaN9LpckCHVY7vMBc2SRvp4JqX3cYTtcG=nQ@mail.gmail.com>
Date: Thu, 8 Nov 2012 10:04:11 -0500
Message-ID: <CACLa4pv-dutho5OokuoRUYxJ1noNOZV04wvcyQe3wmS9Ux2HPg@mail.gmail.com>
Subject: Re: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
From: Eric Paris <eparis@parisplace.org>
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then it only works by accident that magic.h is included by some random
path in smackfs.c.  You really should be including it in smack.h (or
each .c file individually, up to casey)

On Thu, Nov 8, 2012 at 5:43 AM, Jarkko Sakkinen <jarkko.sakkinen@iki.fi> wrote:
> On Tue, Nov 6, 2012 at 11:59 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>
>> On 11/6/2012 12:17 AM, Jarkko Sakkinen wrote:
>> > SMACK_MAGIC moved to a proper place for easy user space access
>> > (i.e. libsmack).
>> >
>> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
>> > ---
>> >  include/uapi/linux/magic.h |    1 +
>> >  security/smack/smack.h     |    5 -----
>> >  2 files changed, 1 insertion(+), 5 deletions(-)
>>
>> Will security/smack/smack_lsm.c and security/smack/smackfs.c
>> compile after this change?
>
> Sorry I haven't replied earlier. Anyway, I made a sanity check.
>
> I retried build from clean. Works. I also checked that vmlinux contains
> SMACK symbols. It does.
>
>>
>> >
>> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
>> > index e15192c..12735ad 100644
>> > --- a/include/uapi/linux/magic.h
>> > +++ b/include/uapi/linux/magic.h
>> > @@ -11,6 +11,7 @@
>> >  #define DEBUGFS_MAGIC          0x64626720
>> >  #define SECURITYFS_MAGIC     0x73636673
>> >  #define SELINUX_MAGIC                0xf97cff8c
>> > +#define SMACK_MAGIC          0x43415d53      /* "SMAC" */
>> >  #define RAMFS_MAGIC          0x858458f6      /* some random number */
>> >  #define TMPFS_MAGIC          0x01021994
>> >  #define HUGETLBFS_MAGIC      0x958458f6      /* some random number */
>> > diff --git a/security/smack/smack.h b/security/smack/smack.h
>> > index 99b3612..8ad3095 100644
>> > --- a/security/smack/smack.h
>> > +++ b/security/smack/smack.h
>> > @@ -149,11 +149,6 @@ struct smack_known {
>> >  #define SMACK_CIPSO_SOCKET   1
>> >
>> >  /*
>> > - * smackfs magic number
>> > - */
>> > -#define SMACK_MAGIC  0x43415d53 /* "SMAC" */
>> > -
>> > -/*
>> >   * CIPSO defaults.
>> >   */
>> >  #define SMACK_CIPSO_DOI_DEFAULT              3       /* Historical */
>>
>
> /Jarkko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
