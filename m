Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2BRG4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:56:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33791 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820Ab2BRG4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:56:03 -0500
Message-ID: <1329548162.1753.13.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jorgyano Vieira <jorgyano@gmail.com>, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, jarod@wilsonet.com, nsankar@broadcom.com,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 22:56:02 -0800
In-Reply-To: <20120218064039.GD2912@mwanda>
References: <1329521976-1326-1-git-send-email-jorgyano@gmail.com>
	 <20120218062534.GB2855@mwanda> <1329546625.1753.7.camel@joe2Laptop>
	 <20120218064039.GD2912@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 09:40 +0300, Dan Carpenter wrote:
> On Fri, Feb 17, 2012 at 10:30:25PM -0800, Joe Perches wrote:
> > On Sat, 2012-02-18 at 09:25 +0300, Dan Carpenter wrote:
> > > On Fri, Feb 17, 2012 at 09:39:36PM -0200, Jorgyano Vieira wrote:
> > > > Replace the usage of BCMLOG_ERR with pr_err and remove the macro definition.
> > > This needs a pr_fmt line so we can tell where the errors are coming
> > > from.
> > > #define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LINE__
> > True.
> > __func__ and __LINE__ are not generally useful though.
> If you don't know the function and line number, then how do you
> tell all the "Invalid args" printks apart?

It's possible to add "%s...", __func__ to
the necessary uses.  Adding it to the generic
is likely overkill.

But is it really necessary anyway?

Aren't those called via some specific notifier
such that the output would make sense given
some specific invalid input?


