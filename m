Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1HHSsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:48:43 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56469 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753583Ab1HHSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:48:42 -0400
Date: Mon, 8 Aug 2011 11:48:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Josef Lusticky <jlustick@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Unable to handle kernel paging request
Message-Id: <20110808114840.c0cbabef.rdunlap@xenotime.net>
In-Reply-To: <4E3FD98C.8040607@redhat.com>
References: <4E3FD98C.8040607@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Aug 2011 14:41:48 +0200 Josef Lusticky wrote:

> 1.
> I get kernel panic when loading and unloading presented modules saying 
> BUG: Unable to handle kernel paging request.
> 
> 2.
> I've written short script that finds all available modules on system and 
> tries to
> load and unload them - see attachment or http://pastebin.com/dphQp2D3
> I've tried several machines with different kernels and architectures
> and always got kernel panic, oops or not responding system.
> The problem is the panic is always caused by different module on 
> different machines and with different kernels but some of call traces 
> are similar and they always begin with "BUG: unable to handle kernel 
> paging request at" + address.
> I've been using module-init-tools 3.9 and 3.16 (most recent).
> Here are examples of output:
> stable kernel 3.0 on x86_64 machine: http://pastebin.com/WKAEdSjE

Now that pastebin is working again:

The 3.0 oops is fixed by this git commit:
7676e345824f162191b1fe2058ad948a6cf91c20
which was merged on July 28.
Dave Miller wrote that he would submit it for -stable also.

Um, same fix for the 2.6.39.3 oops.

BTW, just putting the kernel oops logs inline in the email (or even as
attachments) is usually preferable to making someone use a web browser
to view them.


> stable kernel 2.6.39.3 on x86_64 machine: http://pastebin.com/3XNy5n3B
> stable lts kernel 2.6.32.43 on x86_64 machine: http://pastebin.com/rYzH6y2B
> stable lts kernel 2.6.32.43 on i386 machine: http://pastebin.com/qSnLTch2
> 
> The problem does not occur when loading and unloading one module.
> The problem does not occur after certain amounts of loaded modules.
> When I choose a different order of modules (e.g. using sort) I get panic 
> on different module.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
