Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0C3Wuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:50:40 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60607 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0C3Wui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFCHq2DS+GK+DUPGjFgK/z6eTitCwx7Z7qO2uRfu0M+laLJppMyN0vd5Kq7wXtJd97
         SL7547hJ30ID8iVRtMlykOzKaSDRKIRm8yyg93Gw0AUu940hgkAScQwJR39ZyV2NRZEe
         mMxlnJXLH/nYoScnZW+CIU97BMSluJdvj7Vfc=
Date: Wed, 31 Mar 2010 00:50:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 9/9] tty: implement BTM as mutex instead of BKL
Message-ID: <20100330225038.GA5817@nowhere>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <1269982580-9361-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269982580-9361-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 10:56:20PM +0200, Arnd Bergmann wrote:
> +config TTY_MUTEX
> +	bool "Use a mutex instead of BKL for TTY locking"
> +	depends on EXPERIMENTAL && SMP


You still need it on UP-PREEMPT.

The bkl disables preemption so you need to "reproduce"
this atomicity by locking your path.

