Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1FLBBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 21:01:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab1FLBBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 21:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110611.175834.1802167158365693401.davem@davemloft.net>
References: <1307711453-17412-1-git-send-email-minipli@googlemail.com>
 <20110611.160842.2135350880385482648.davem@davemloft.net> <20110611234415.GE11521@ZenIV.linux.org.uk>
 <20110611.175834.1802167158365693401.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Jun 2011 18:01:06 -0700
Message-ID: <BANLkTikU44wjhzSLxP9XPcpsfkhQaGhayw@mail.gmail.com>
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
To: David Miller <davem@davemloft.net>
Cc: viro@zeniv.linux.org.uk, minipli@googlemail.com, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 5:58 PM, David Miller <davem@davemloft.net> wrote:
>
> The reason the test is only in this specific spot, is that's the only
> place where the optimization makes any sense.

Well, considering that it didn't make any sense there *either*, that's
kind of pointless.

We always had the unconditional "set_fs()" in the exec path. It only
got moved, and as part of that conscious effort, the pointless
architecture churn is getting cleaned up.

                         Linus
