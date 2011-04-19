Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1DSPI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:08:57 -0400
Received: from mail.aknet.ru ([78.158.192.28]:42671 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1DSPI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:08:56 -0400
Message-ID: <4DADA581.9060700@aknet.ru>
Date: Tue, 19 Apr 2011 19:08:49 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
References: <20110224132906.GA15733@redhat.com>	<4D6675B0.2010700@aknet.ru>	<20110224153221.GA22770@redhat.com>	<4D94A788.1050806@aknet.ru>	<20110331170244.GA13271@redhat.com>	<4D99D6E6.4070008@aknet.ru>	<20110404160351.GA23655@redhat.com>	<4D9A24A0.5050105@aknet.ru>	<20110405151549.GB17490@redhat.com>	<4D9B4265.6080403@aknet.ru>	<20110405164557.GA23248@redhat.com>	<4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419155830.7ad33312@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.04.2011 18:58, Alan Cox wrote:
>> The attached patch implements the PR_DETACH prctl
>> command. It detaches the entire process group from
>> its parent, allowing the parent to still read the detach
>> code with normal wait(). If the process then exits, the
>> notification of the new parent is delayed till the old parent
>> does either wait() to read the detach code, or exits.
> What is the use case for this and why won't existing process group
> interfaces do the job ?
The use case is to daemonize the process with threads.
You first need to detach it from its parent, then use TIOCNOTTY
ioctl to detach from the tty (TIOCNOTTY_GRP doesn't seem
to exist too, though, but might be easy to implement).
There are a few workarounds to that that I am aware of,
but what exactly interfaces do you have in mind? I have
found nothing that allows to do the same without a workarounds
like this:
https://lkml.org/lkml/2011/4/8/278
The current way of detaching, which is a fork/exit combo,
loses all threads, so, when you call daemon() and you had
threads, you are a toast.
