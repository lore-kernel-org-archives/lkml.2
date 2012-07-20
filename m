Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2GTPt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:49:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44111 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753179Ab2GTPt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:49:58 -0400
Message-ID: <1342799397.21447.35.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Add checks for do {} while (0) macro misuses
From: Joe Perches <joe@perches.com>
To: Betty Dall <betty.dall@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Fri, 20 Jul 2012 08:49:57 -0700
In-Reply-To: <loom.20120720T160308-562@post.gmane.org>
References: <1342735885.17350.3.camel@joe2Laptop>
	 <loom.20120720T160308-562@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 14:40 +0000, Betty Dall wrote:

> I reviewed this and tested it out on the qib.h file we were looking at yesterday 
> and it worked well. I was worried about a nested do {} while(0), because it will 
> match with the first while. Here is a test case:
> #define qib_devinfo(pcidev, fmt, ...) \
>         do { \
>                 do { \
>                         dev_info(&(pcidev)->dev, fmt, ##__VA_ARGS__); \
>                 } while (0); \
>         } while (0)
> 
> Checkpatch.pl didn't complain about that one. Granted, it is a contrived test 
> case. Your change will catch the real problems.

Hi Betty.

Wow, you're thorough.  Thanks for testing.

I don't mind that it doesn't work in all cases.
I suppose this would fail for loops too.

checkpatch is a pretty limited tool as it depends on
the code being compilable and doesn't really understand
c syntax.  It is just a convenience tool and lots of
its logic is incomplete and some of its output can be
happily ignored.

cheers, Joe

