Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2EGB7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:59:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35949 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754893Ab2EGB7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:59:35 -0400
Message-ID: <1336355974.8617.6.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
From: Joe Perches <joe@perches.com>
To: Pierre Carrier <pierre@spotify.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 06 May 2012 18:59:34 -0700
In-Reply-To: <1336353614-7944-1-git-send-email-pierre@spotify.com>
References: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
	 <1336353614-7944-1-git-send-email-pierre@spotify.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 03:20 +0200, Pierre Carrier wrote:
> number()'s behaviour is slighly changed:
> 0 becomes "0" instead of "00" when using the flag SPECIAL and base 8.
> 
> Before:
> Number\Format  %o    %#o  %x    %#x
>             0     0   00    0   0x0
>             1     1   01    1   0x1
>            16    20  020   10  0x10
> 
> After:
> Number\Format  %o    %#o  %x    %#x
>             0     0    0    0   0x0
>             1     1   01    1   0x1
>            16    20  020   10  0x10

If you do this, why not change 0-7 instead of just 0?


