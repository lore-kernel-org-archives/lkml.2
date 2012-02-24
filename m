Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2BXXAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:00:48 -0500
Received: from r00tworld.com ([212.85.137.150]:49194 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2BXXAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:00:47 -0500
From: "PaX Team" <pageexec@freemail.hu>
To: Nick Bowler <nbowler@elliptictech.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Date: Fri, 24 Feb 2012 23:59:47 +0200
MIME-Version: 1.0
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Reply-to: pageexec@freemail.hu
CC: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        David Windsor <dwindsor@gmail.com>,
        Roland Dreier <roland@purestorage.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        kernel-hardening@lists.openwall.com,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, spender@grsecurity.net
Message-ID: <4F481663.5371.216F475B@pageexec.freemail.hu>
In-reply-to: <20120224191300.GA12553@albatros>
References: <20120217075945.GA2831@albatros>, <20120224190549.GA8034@elliptictech.com>, <20120224191300.GA12553@albatros>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 24 Feb 2012 23:59:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Feb 2012 at 23:13, Vasiliy Kulikov wrote:

> > But in this case, the principle does not apply because we can recover.
> > The reason we cannot recover from the stack protector case is because
> > the stack protector is reacting after the fact, which is not the case
> > here.  Simply peg the reference count at the maximum value, neither
> > incrementing it nor decrementing it further.
> 
> ...and simply loose one reference, which leads to use-after-free.

saturating the refcount keeps the protected object allocated, so it is
a memory leak, but it is not a use-after-free.

