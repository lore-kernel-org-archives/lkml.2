Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0C3Wex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:34:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753670Ab0C3Wev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:34:51 -0400
Date: Tue, 30 Mar 2010 23:37:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Message-ID: <20100330233759.00877e80@lxorguk.ukuu.org.uk>
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This means we are still safe, because there is no code
> left that the new BTM fails to serialize with.

We hope. I'm currently poking at sorting out the locking properly and
quite frankly the locking rules for the current tty reference have me
baffled. It clearly works as we've not got a pile of dumps in the
bugzilla tree but its also quite a mystery *how*.

