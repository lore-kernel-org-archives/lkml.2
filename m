Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1CKOy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:54:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1CKOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:54:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] tty: serial: Use hub6_serial_X when CONFIG_SERIAL_8250_HUB6 is defined
Date: Fri, 11 Mar 2011 15:54:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com> <201103111456.15705.arnd@arndb.de> <20110311143010.3aef5873@lxorguk.ukuu.org.uk>
In-Reply-To: <20110311143010.3aef5873@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111554.38487.arnd@arndb.de>
X-Provags-ID: V02:K0:9V6fLBwf3iafnnU6hbjtIqbyZgilGxLI44yI3du+ygX
 xiro+pxZPCfvp6WBLHmShIUYVUBiMNXJnJrga4UP0rmv5+NlX+
 4kNT5u5tVXDlHgcATVT7YnZdAqcQQbVuB/ylbVru3XXFryWm/m
 S9d/qGwDOX1cMWQ1c5wH9a7e/+hJYjkW+Qev1ZLddjUBEkOwyx
 7df6YbZg7pI44icF82qgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Alan Cox wrote:
> > or some variation of this. It's fine as long as this code never gets
> > called, but incorrect nonetheless.
> 
> I disagree - the WARN(1) is certainly correct.

Yes. I wrote this before I saw your other reply where you suggest
the use of WARN_ON().

So while technically correct, I still tend to prefer build warnings
over run-time warnings for things that we know about at build time.

> > I think it would be much cleaner if architectures that cannot do this
> > would not have to define those functions and we could make sure that
> > all drivers that do inb() have correct Kconfig dependencies.
> 
> For 8250 the way to do that is to remove all the switches and port type
> stuff and propogate to setting ->serial_in and ->serial_out rather than
> splattering the code with ifdefs. At that point you'd have a "lib8250" or
> similar and an 8250_io/pci driver.

Right, this absolutely makes sense. It's a lot more work than the originally
suggested patch, but the result is much cleaner.

	Arnd
