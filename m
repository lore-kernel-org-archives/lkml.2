Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2KLQ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:57:12 -0500
Received: from c62.cesmail.net ([216.154.195.54]:9530 "EHLO c62.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2KLQ5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:57:10 -0500
Message-ID: <20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
Date: Mon, 12 Nov 2012 11:57:07 -0500
From: Pavel Roskin <proski@gnu.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash
	plugin
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
	<20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
	<CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
In-Reply-To: <CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris <eparis@parisplace.org>:

> OMG this +1 -1 stuff is nuts...
>
> iterate_fd passes fd+1 instead of the fd for the file?  seriously?
> ewwww.  I see how this patch fixes it, but still, wouldn't some magic
> or negative value for no entries found be better than having to
> understand the crazy logics?

I agree.  -ENOENT is both magic and negative :)

I tend to think now that iterate_fd() should be rewritten before it's too
late and all its current users should be cross-checked against the
code prior to the introduction of iterate_fd().

-- 
Regards,
Pavel Roskin
