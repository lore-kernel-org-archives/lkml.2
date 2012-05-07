Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2EGCUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:20:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61294 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2EGCUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <1336355974.8617.6.camel@joe2Laptop>
References: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
	<1336353614-7944-1-git-send-email-pierre@spotify.com>
	<1336355974.8617.6.camel@joe2Laptop>
Date: Mon, 7 May 2012 04:20:18 +0200
Message-ID: <CAPXGRDkgEKFU7fVDqz33C9vqjdxmBYTbPEPbcfhpkg0NxOJz-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
From: Pierre Carrier <pierre@spotify.com>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 3:59 AM, Joe Perches <joe@perches.com> wrote:
> If you do this, why not change 0-7 instead of just 0?

Consistency with POSIX *printf.

"#: Specifies that the value is to be converted to an alternative
form. For o conversion, it increases the precision (if necessary) to
force the first digit of the result to be zero."
-- http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html

% cat octal.c;gcc -o octal octal.c;./octal
#include <stdio.h>
void main() {
        int i;
        for (i=0;i<10;i++) printf("%#o ", i);
        puts("");
}
0 01 02 03 04 05 06 07 010 011

-- 
Pierre
