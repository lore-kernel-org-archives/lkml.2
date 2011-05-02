Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1EBXVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:21:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1EBXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110502231234.GA6430@suse.de>
References: <201105030044.51661.rjw@sisk.pl> <20110502231234.GA6430@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 May 2011 16:21:09 -0700
Message-ID: <BANLkTikCHO1ST27uhJLU5mBxtWPuuVkNKA@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 4:12 PM, Greg KH <gregkh@suse.de> wrote:
>
> But you can safely call this function with nowait set, and this warning
> should not be triggered, right?

Why would you want that?

It's _always_ wrong to ask for firmware during resume. "nowait" or not
is totally irrelevant. A driver that depends on the firmware being
built in to the kernel is a buggy driver, why would you want to
silently allow that kind of crap? It's just a timebomb waiting for
somebody to compile the kernel differently.

                      Linus
