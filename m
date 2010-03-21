Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0CUHbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:31:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:50181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0CUHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OEx2nNusyOQipcvEUBTdA35EZQn2BFFQSh7I4G0xd5bfs9QW2Sm4lUbR2plKm6gcbN
         D4/OvBqsDiO8LAGX4F4amEHLmkDQsJC7BbSIruy8JISzQ8LP3K/X9BYu/eMCp9RWk8hH
         lSEGkGYk8NEMHJrly2qEVnUfNQohrNI7BWR4I=
MIME-Version: 1.0
In-Reply-To: <fa686aa41003191048s5c4c85ablc4588725a3d615ad@mail.gmail.com>
References: <cabda6421003190139h344bc172h3556fca78e4b25cb@mail.gmail.com>
	 <1268987934-22690-1-git-send-email-chripell@fsfe.org>
	 <fa686aa41003191048s5c4c85ablc4588725a3d615ad@mail.gmail.com>
Date: Sun, 21 Mar 2010 08:31:39 +0100
X-Google-Sender-Auth: 7e360e3c35eb5068
Message-ID: <cabda6421003210031k65e9d195u90fc99888ca7633c@mail.gmail.com>
Subject: Re: [PATCH 1/3] max3100: added raise_threaded_irq
From: christian pellegrin <chripell@fsfe.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, alan@lxorguk.ukuu.org.uk,
       spi-devel-general@lists.sourceforge.net, linux-serial@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Mar 19, 2010 at 6:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> You should cc: Thomas and Ingo and lkml (which I just did) on patches
> to the threaded interrupt code.
>

ok, let me explain the reason for this function. The move from
worqueues to the threaded interrupts was motivated by a reduction of
latency in answering to RX buffer full interrupts. Threaded interrupts
are SCHED_FIFO instead worqueues being SCHED_OTHER. In the case of
MAX31x0 when we transmit a character we could have to receive one
(this is efficient because SPI transfers are quite always
bidirectional). The same routine is used both for tx and rx (an other
things like changing parameters): this makes locking really simple.
With this routine the thread interrupt handler could be the only kind
of deferred work a driver for a simple hardware may ever need.

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
