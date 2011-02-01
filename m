Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1BATrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:47:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55783 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1BATrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G5PKgWPc6kDCzMnhi8Mgqzh3TOIpI6YPa6Jvg/5t69LsENkxI2YvK2bGbSt45pGK64
         20EThrbzBhc08/auouZsYRhcaCJrr1ABOFAMNNktH0vYfMKR0mKsU7eT5VfA5D5gp3XI
         lhv/+j14WM1x2Pirp5bEgirJ/Isv3grTxHTlc=
MIME-Version: 1.0
In-Reply-To: <m1r5brr1mn.fsf@fess.ebiederm.org>
References: <1296578246.12605.22.camel@moss-pluto> <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
 <m1r5brr1mn.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 1 Feb 2011 21:46:42 +0200
Message-ID: <AANLkTik+N5J-MDrbMbtwRPwz==J4y8sbBkhir=1K3g=B@mail.gmail.com>
Subject: Re: [PATCH 1/2] security/selinux: fix /proc/sys/ labeling
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 9:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> What kernel has a dentry_path_raw?  Perhaps you mean __dentry_path?


See the function here:
https://github.com/mirrors/linux-2.6/blob/70d1f365568e0cdbc9f4ab92428e1830fdb09ab0/fs/dcache.c

The last patches were against 2.6.38-rc2 because the dcache layer got
rewritten in 2.6.38 http://lwn.net/Articles/421784/

__dentry_path is now static (in fs/dcache.c) and does not take the
necessary locks.

dentry_path_raw is __dentry_path with locks

    ec2447c278ee973d35f38e53ca16ba7f965ae33d
    hostfs: simplify locking

    Remove dcache_lock locking from hostfs filesystem, and move it into dcache
    helpers. All that is required is a coherent path name. Protection from
    concurrent modification of the namespace after path name generation is not
    provided in current code, because dcache_lock is dropped before the path is
    used.

    Signed-off-by: Nick Piggin <npiggin@kernel.dk>



-- 
 .
..: Lucian
