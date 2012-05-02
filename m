Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2EBQPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 12:15:08 -0400
Received: from imr4.ericy.com ([198.24.6.9]:59987 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2EBQPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 12:15:07 -0400
Message-ID: <1335975202.2324.12.camel@groeck-laptop>
Subject: Re: checkpatch: kstrtol fix
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Joe Korty <joe.korty@ccur.com>
CC: Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 May 2012 09:13:22 -0700
In-Reply-To: <20120502151046.GA25594@tsunami.ccur.com>
References: <20120502151046.GA25594@tsunami.ccur.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 11:10 -0400, Joe Korty wrote:
> kstrtol is a substitute for simple_strtol() only when when second
> arg of simple_strtol() is NULL. For any other value the functionality
> of simple_strtol() cannot be implemented in terms of kstrtol.
> 
> So modify checkpatch.pl so that it prints out the following warning only
> if the second argument is null:
> 
>    WARNING: simple_strtol is obsolete, use kstrtol instead
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 

I think this would be a bad idea. Most if not all instances in the
kernel (at least all the ones I looked at) use the second argument to
determine if the parameter was actually a number or not, ie it is used
to detect parameter errors. This is exactly the point of using kstrtol()
in the first place. So it _is_ possible, at least in most cases, to
implement the same functionality with kstrtol(). If there _are_ uses of
simple_strtol() where the second argument is not used for error checking
but for some other purpose, I am sure that an alternative solution can
be found which does not require simple_strtol(). Or just live with the
warning for those cases.

Thanks,
Guenter


