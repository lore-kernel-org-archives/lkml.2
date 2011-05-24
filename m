Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1EXRf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab1EXRfZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=U8ikZo65AoxGznCopGMTFOUXWhQ@mail.gmail.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au> <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
 <BANLkTine2kobQA8TkmtiuXdKL=07NCo2vA@mail.gmail.com> <BANLkTim-zRShhy49d7yn5WTJYzR6A2DtZQ@mail.gmail.com>
 <BANLkTi=U8ikZo65AoxGznCopGMTFOUXWhQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 10:29:58 -0700
Message-ID: <BANLkTi=7wfhw-J09U7X-crKcDUPwpzbsNA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, "Balbi, Felipe" <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:10 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> latest tree seems to only fail for me now on the musb driver.  i can
> send out a patch later today if no one else has gotten to it yet.

Please do.

I did a

  grep -L linux/prefetch.h $(git grep -l '[^a-z_]prefetchw*(' -- '*.[ch]')

but there are drivers out there that have that "prefetch()" pattern
without being about actual CPU prefetching at all (see for example
drivers/ide/cmd640.c), so once I got allyesconfig with my x86
detection hack going, I didn't bother with the few odd men out.

                  Linus
