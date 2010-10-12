Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab0JLNGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:06:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56118 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab0JLNGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:06:12 -0400
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Cc: Steve Grubb <sgrubb@redhat.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <201010121414.14486.ozan@pardus.org.tr>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1007021015490.2400@tundra.namei.org>
	 <201010121414.14486.ozan@pardus.org.tr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 09:06:09 -0400
Message-ID: <1286888769.2670.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 14:14 +0300, Ozan Çağlayan wrote:
> Cuma 02 Temmuz 2010 günü (saat 03:16:01) James Morris şunları yazmıştı:
> > On Thu, 1 Jul 2010, Mimi Zohar wrote:
> > > Make the security extended attributes names global. Updated to move
> > > the remaining Smack xattrs.
> > > 
> > > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > 
> 
> This drops 
> 
> #define XATTR_CAPS_SUFFIX "capability"
> #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> 
> definitions from capability.h and puts them in xattr.h's #ifdef __KERNEL__ 
> section making them invisible to userspace like libcap-ng causing build 
> failures.
> 
> Am I wrong?

You're correct.  It's the same reason that cap-ng.c has to define
'security'.

#ifdef VFS_CAP_U32
 #include <attr/xattr.h>
 #define XATTR_SECURITY_PREFIX "security."

Am cc'ing Steve.

Mimi

