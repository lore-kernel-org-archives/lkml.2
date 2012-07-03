Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2GCOJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:09:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48415 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2GCOJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:09:37 -0400
Date: Tue, 3 Jul 2012 15:13:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] fs/sysv: stop using write_super and s_dirt
Message-ID: <20120703151313.36e85254@pyramind.ukuu.org.uk>
In-Reply-To: <1341323008-29414-4-git-send-email-dedekind1@gmail.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	<1341323008-29414-4-git-send-email-dedekind1@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drity and then setting the s_dirt flag. And when 'write_super()' is executed to
> handle the s_dirt flag, we just update the timestamp and again mark the
> superblock buffer as dirty. Seems pointless.

It's the way sysv itself does stuff. The timestamp on v7/sys3/sys5
reflects the clock on the box. A lot of ancient boxes with no decent
hardware clocks used to reset the system time off the root fs superblock
on a loss of power.

Alan
