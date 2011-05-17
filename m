Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1EQLaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:30:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62117 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1EQLaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:30:07 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.10]
In-Reply-To: <BANLkTimZjTT1B2BxZdrEMMh+e-6ScL0T-w@mail.gmail.com>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	<20110331112559.090948a7@lxorguk.ukuu.org.uk>
	<AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
	<20110331143329.GA14441@home.goodmis.org>
	<AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
	<1301665592.2160.19.camel@gandalf.stny.rr.com>
	<BANLkTik5MGz9YgU0oh30ZUesv+c3QEB+rA@mail.gmail.com>
	<1302008671.17430.10.camel@frodo>
	<BANLkTimZjTT1B2BxZdrEMMh+e-6ScL0T-w@mail.gmail.com>
Date: Tue, 17 May 2011 17:00:05 +0530
Message-ID: <BANLkTimm=e_fcHA-5fnT-2zQNORuJwijng@mail.gmail.com>
Subject: Re: locks inside receive_buf
From: Pavan Savoy <pavan_savoy@sify.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip....>
Well apparently I can't sleep long enough, as in from inside the
tty_receive() I cannot do a tty->ops->write and wait for receive() -
since there is 1 receive_buf for 1 tty ....

Well I do have a requirement, where I must send some data from inside
the receive_buf function of a line discipline driver wait for a
certain kind of response and then proceed doing something else.

scheduling a work upon the default worker thread also doesn't seem to
be helping and the tty_receive() handler is called only after the wait
inside the work struct handler is done...

So any suggestions?
should I create a new worker thread ? or any thing simpler ?
