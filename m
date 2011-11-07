Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1KGNoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:44:44 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:33360 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1KGNon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:44:43 -0500
Message-ID: <4EB7E0C6.7050909@ilyx.ru>
Date: Mon, 07 Nov 2011 17:44:38 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function flush_to_ldisc().
References: <4EB7BD9A.7070600@ilyx.ru>	<20111107115802.23201d45@bob.linux.org.uk>	<4EB7CCFF.5090304@ilyx.ru> <20111107130643.07e84fca@bob.linux.org.uk>
In-Reply-To: <20111107130643.07e84fca@bob.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> 
>> Why we need: "if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {"
>> if flush_to_ldisc is single threaded?
>> we can: set_bit(TTY_FLUSHING, &tty->flags)
>> without if() at all.
> 
> It is single threaded with respect to itself (you can't have two
> flush_to_ldisc on the same tty at once) but you can have a parallel
> call to tty_buffer_flush. The tty_buffer_flush path needs to pick the
> right approach reliably.
> 


Of course I know about tty_buffer_flush(), it only read TTY_FLUSHING,
it can't change TTY_FLUSHING, if flush_to_ldisc() single threaded,
we can change TTY_FLUSHING only in one place in one time(in flush_to_ldisc()),
therefor we can use only "set_bit(TTY_FLUSHING, &tty->flags)" without test.

