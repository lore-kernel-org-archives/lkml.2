Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1DSQTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:19:24 -0400
Received: from mail.aknet.ru ([78.158.192.28]:60373 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1DSQTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:19:23 -0400
Message-ID: <4DADB603.1020403@aknet.ru>
Date: Tue, 19 Apr 2011 20:19:15 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
References: <20110224132906.GA15733@redhat.com>	<4D6675B0.2010700@aknet.ru>	<20110224153221.GA22770@redhat.com>	<4D94A788.1050806@aknet.ru>	<20110331170244.GA13271@redhat.com>	<4D99D6E6.4070008@aknet.ru>	<20110404160351.GA23655@redhat.com>	<4D9A24A0.5050105@aknet.ru>	<20110405151549.GB17490@redhat.com>	<4D9B4265.6080403@aknet.ru>	<20110405164557.GA23248@redhat.com>	<4DADA22A.1010205@aknet.ru>	<20110419155830.7ad33312@lxorguk.ukuu.org.uk>	<4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.04.2011 19:54, Alan Cox wrote:
>> The use case is to daemonize the process with threads.
>> You first need to detach it from its parent, then use TIOCNOTTY
>> ioctl to detach from the tty (TIOCNOTTY_GRP doesn't seem
>> to exist too, though, but might be easy to implement).
>> There are a few workarounds to that that I am aware of,
>> but what exactly interfaces do you have in mind? I have
>> found nothing that allows to do the same without a workarounds
>> like this:
>> https://lkml.org/lkml/2011/4/8/278
>> The current way of detaching, which is a fork/exit combo,
>> loses all threads, so, when you call daemon() and you had
>> threads, you are a toast.
> Yes - you need to detach then create the threads.
That's painful sometimes:
https://lkml.org/lkml/2011/4/8/266

> The reason I ask is you appear to add overhead to various hot paths and
> you add 48 bytes to each task struct if I read the code right. Thats half
> a megabyte on a server running a pile of java gunge !
I don't think there is a real code overhead: the new list is
always empty (unless you detach). But the memory overhead
is real. Can be shrunk though.
Well, there is always an option to leave that patch for my own
project if people dislike it too much.
But I'd like to know the margins, i.e. how much memory is acceptable?
Eg, if it only uses 8 extra bytes (one pointer), is it acceptable then,
or not in any case? What is the policy?
