Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0KCR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0KCR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:57:58 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
Date: Wed, 3 Nov 2010 13:57:37 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.33.8-149.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com> <201011031300.31522.sgrubb@redhat.com> <1288805913.2939.53.camel@localhost.localdomain>
In-Reply-To: <1288805913.2939.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011031357.37976.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 03, 2010 01:38:33 pm Mimi Zohar wrote:
> > > As long as we're making this change, should 'security' also be defined
> > > outside of the __kernel__ definitions?
> >
> > I guess no one fixed this before 2.6.36 was finalized. Removing the
> > define has broke user  space compilation for anything that works on file
> > based capabilities. I can define it myself, but if the kernel folks ever
> > change the string, then we have more than just a compile problem, we
> > have runtime problems because I can no longer use the correct string.
> >
> > So, what was the gain for breaking user space?
> >
> > -Steve
> 
> Sorry I dropped the ball. Was expecting some kind of response to my
> question above, and then forgot about it.
> 
> All of the 'security' xattrs were moved to fsmagic.h, including
> capability. Not only those that EVM protects, but others like
> XATTR_NAME_SMACKIPIN/OUT (based on Casey's request).

If user space has to know the exact contents of a string in order to do something that 
the kernel understands, then its part of a public API. I've made my own define and 
released a new copy of libcap-ng. So, if the contents of the string ever change, or 
becomes deprecated, you'll now have user space apps using the old values no matter 
what.

-Steve
