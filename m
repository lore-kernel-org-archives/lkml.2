Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0HQLhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0HQLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:37:45 -0400
Subject: Re: selinux build error -
 =?UTF-8?Q?=E2=80=98FILE=5F=5FAUDIT=5FACCESS=E2=80=99?= undeclared
From: Eric Paris <eparis@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Stephen D. Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1282032919.11858.8.camel@minggr.sh.intel.com>
References: <1282032919.11858.8.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 07:37:30 -0400
Message-ID: <1282045050.21419.119.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 16:15 +0800, Lin Ming wrote:
> Current -tip(a3b97ee) tree build error.
> My config attached.
> 
> linux-2.6/security/selinux/hooks.c: In function ‘selinux_inode_permission’:
> linux-2.6/security/selinux/hooks.c:2647:38: error: ‘FILE__AUDIT_ACCESS’ undeclared (first use in this function)
> 
> It was introduced by below commit.
> 
> commit b782e0a68d17894d9a618ffea55b33639faa6bb4
> Author: Eric Paris <eparis@redhat.com>
> Date:   Fri Jul 23 11:44:03 2010 -0400
> 
>     SELinux: special dontaudit for access checks
> 
> Lin Ming

did you build with O= ?

Fixed in a7a387cc596278af1516c534b50cc0bee171129d but you have to run
make clean.  If you want to fix it up by hand run:

find . -name av_pernmissions.h | xargs rm

Your builds will work find after that.

-Eric

