Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2GTOpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:45:11 -0400
Received: from plane.gmane.org ([80.91.229.3]:47716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2GTOpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:45:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Betty Dall <betty.dall@hp.com>
Subject: Re: [PATCH] checkpatch: Add checks for do =?utf-8?b?e30=?= while (0) macro misuses
Date: Fri, 20 Jul 2012 14:40:46 +0000 (UTC)
Message-ID: <loom.20120720T160308-562@post.gmane.org>
References: <1342735885.17350.3.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 15.219.153.79 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Perches <joe <at> perches.com> writes:

> 
> These types of macros should not be used for either a
> single statement nor should the macro end with a semi-colon.
> 
> Add tests for these conditions.
> 
> Signed-off-by: Joe Perches <joe <at> perches.com>
> ---
>  scripts/checkpatch.pl |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)


I reviewed this and tested it out on the qib.h file we were looking at yesterday 
and it worked well. I was worried about a nested do {} while(0), because it will 
match with the first while. Here is a test case:
#define qib_devinfo(pcidev, fmt, ...) \
        do { \
                do { \
                        dev_info(&(pcidev)->dev, fmt, ##__VA_ARGS__); \
                } while (0); \
        } while (0)

Checkpatch.pl didn't complain about that one. Granted, it is a contrived test 
case. Your change will catch the real problems.

-Betty



