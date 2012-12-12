Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2LLI6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:58:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:45990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2LLI6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:58:39 -0500
Date: Wed, 12 Dec 2012 09:56:16 +0100
From: Benedikt Spranger <b.spranger@linutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 2/2] uio: do not expose inode to uio open/release hooks
Message-ID: <20121212095616.357a59e9@mitra.spranger.biz>
In-Reply-To: <20121212085053.GF2642@local>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
	<1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
	<20121211232032.GA24933@kroah.com>
	<20121212014221.GA2642@local>
	<20121212044648.GB7224@kroah.com>
	<20121212085053.GF2642@local>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 12 Dec 2012 09:50:54 +0100
schrieb "Hans J. Koch" <hjk@hansjkoch.de>:

> On Tue, Dec 11, 2012 at 08:46:48PM -0800, Greg KH wrote:
> > Yes, but what does that have to do with this in-kernel, internal api?
> 
> Ah, OK. You're right, the commit message is confusing.
> 
> Bene, it's enough to say we drop the inode parameter because nobody
> ever needed it.
I am fine with that.

> I cannot see why this also helps with the other problem.
It would help, because we can defer calling the release hook until the
last mmap user is gone. In this case the inode pointer may not be valid
anymore.

Regards
    Bene
