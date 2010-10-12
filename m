Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0JLNTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab0JLNTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:19:42 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
Date: Tue, 12 Oct 2010 09:19:11 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.33.8-149.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com> <201010121414.14486.ozan@pardus.org.tr> <1286888769.2670.5.camel@localhost.localdomain>
In-Reply-To: <1286888769.2670.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010120919.11819.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 12, 2010 09:06:09 am Mimi Zohar wrote:
> On Tue, 2010-10-12 at 14:14 +0300, Ozan Çağlayan wrote:
> > Cuma 02 Temmuz 2010 günü (saat 03:16:01) James Morris şunları yazmıştı:
> > > On Thu, 1 Jul 2010, Mimi Zohar wrote:
> > > > Make the security extended attributes names global. Updated to move
> > > > the remaining Smack xattrs.
> > > > 
> > > > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > 
> > This drops
> > 
> > #define XATTR_CAPS_SUFFIX "capability"
> > #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> > 
> > definitions from capability.h and puts them in xattr.h's #ifdef
> > __KERNEL__ section making them invisible to userspace like libcap-ng
> > causing build failures.
> > 
> > Am I wrong?
> 
> You're correct.  It's the same reason that cap-ng.c has to define
> 'security'.
> 
> #ifdef VFS_CAP_U32
>  #include <attr/xattr.h>
>  #define XATTR_SECURITY_PREFIX "security."
> 
> Am cc'ing Steve.

So does this mean I need to provide more definitions for libcap-ng to work with 
future kernels or are you asking my opinion? My opinion is that if user space 
needs it to work correctly, please let it be available so I don't have to make 
my own define which may be inaccurate one day.

Thanks,
-Steve
