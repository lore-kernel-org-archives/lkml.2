Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab0LFGjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 01:39:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37882 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0LFGjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 01:39:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=TqDJi+Xcm42+cp64FTHaPE43BeGKFfam0cw5/Ib3RfmoVZ2iazDKaFLh+PKmWdtf8Y
         drfASYkSs/6GV/unANLaCyHi+qw7BNUXbfkXE3dtxrfnRyO6v43/l+/MH9YWEuw3HVKb
         NbdZ41BTrc2DWaohdBS6Lt5vqKl5g9M7N2YoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Lc=UQCdZa3VjirdhY_VztBjH2yn5hGAEtxte0@mail.gmail.com>
References: <AANLkTik0SRGzo=nbs1z_9QyTwkYGvMQUK_6ShskKFe9u@mail.gmail.com> <AANLkTi=Lc=UQCdZa3VjirdhY_VztBjH2yn5hGAEtxte0@mail.gmail.com>
From: nidhi mittal hada <nidhimittal19@gmail.com>
Date: Mon, 6 Dec 2010 12:09:24 +0530
Message-ID: <AANLkTikTVYWPx311PUp503MWGAZYVB1c3DJa0WJmcyW3@mail.gmail.com>
Subject: Re: beagle-board -high speed data acquisition from - adc --
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-newbie@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I am reframing question in case it remained unclear
......................Its a simple conceptual doubts...please clarify

Simple I want to acquire data from a parallel interface ---- 12 bit
ADC (works at a rate of 40Msamples per second.)----with the Beagle
Board with ..
i want to acquire data from that ADC for a period of 100
msec............with each sample coming from ADC at 25 nanosec....

Now my sequence of task includes --------

For a period of 100msecs

1)BeagleBoard -------gives a start signal to ADC

2)ADC ------>gives back  sample data after 25nseconds--------->for
these 25ns beagle board has to store previous sample in memory ...
may be using DMA !! ...........still undecisive whether DMA is proper
choice or not ..........
------------ process gets an interrupt ....that 25ns are over !!

3)Now goto step 1.........BUT Now beagleboard has to give another
start signal ----without wasting anymore than 1 or 2 ns before giving
another start signal to ADC


that is where i am doubtful .................

as

If i use interrupt handler at after 25ns ...then interrupt latency
itself might take more time than i want to save ............

Q1.Can there be some interrupt handler ....which can just capture data
and gives start signal at highest priority without getting interrupted
by kernel ...?

If i use user mode or kernel mode process ...for this ...how do i
ensure that ...
it doesnt get preempted by anything before it does this critical
operation of capturing data and giving start signal ......

Q2. Can we store sample data in memory in 25 ns we have with us before
getting next sample from ADC ?

Q3.should we use DMA ?




CAN Beagleboard with linux in it ...can achieve such a strict time
constrained requirement ?




Nidhi




On Mon, Dec 6, 2010 at 11:58 AM, nidhi mittal hada
<nidhimittal19@gmail.com> wrote:
>
> Hi all
>
> I am reframing question in case it remained unclear ......................Its a simple conceptual doubts...please clarify
>
> Simple I want to acquire data from a parallel interface ---- 12 bit ADC (works at a rate of 40Msamples per second.)----with the Beagle Board with ..
> i want to acquire data from that ADC for a period of 100 msec............with each sample coming from ADC at 25 nanosec....
>
> Now my sequence of task includes --------
>
> For a period of 100msecs
>
> 1)BeagleBoard -------gives a start signal to ADC
>
> 2)ADC ------>gives back  sample data after 25nseconds--------->for these 25ns beagle board has to store previous sample in memory ...
> may be using DMA !! ...........still undecisive whether DMA is proper choice or not ..........
> ------------ process gets an interrupt ....that 25ns are over !!
>
> 3)Now goto step 1.........BUT Now beagleboard has to give another start signal ----without wasting anymore than 1 or 2 ns before giving another start signal to ADC
>
>
> that is where i am doubtful .................
>
> as
>
> If i use interrupt handler at after 25ns ...then interrupt latency itself might take more time than i want to save ............
>
> Q1.Can there be some interrupt handler ....which can just capture data and gives start signal at highest priority without getting interrupted by kernel ...?
>
> If i use user mode or kernel mode process ...for this ...how do i ensure that ...
> it doesnt get preempted by anything before it does this critical operation of capturing data and giving start signal ......
>
> Q2. Can we store sample data in memory in 25 ns we have with us before getting next sample from ADC ?
>
> Q3.should we use DMA ?
>
>
>
>
> CAN Beagleboard with linux in it ...can achieve such a strict time constrained requirement ?
>
>
>
>
> Nidhi
>
>
>
>
>
>
>
>
> On Sun, Dec 5, 2010 at 12:49 PM, nidhi mittal hada <nidhimittal19@gmail.com> wrote:
> > Hello all
> >
> > Actually
> > I want to use a parallel interface ADC with the Beagle Board with 40Msps.
> > I want to take samples using 12 bit ADC and acquire it for say 100ms.
> >
> > My input signal is 3 V p-p .
> >
> >
> > "Actually in my application after taking sample I want to calculate
> > 4096 point FFT using it.
> > During this time i don't require to acquire input signal. Then the
> > calculated data has to
> > be passed to a PC using on board USB or UART interface.
> > Some more complex operations are also there such as correlations and
> > Principal Component analysis."
> >
> > Please suggest whether beagle board is apt for such project.
> >
> > My major concern is high speed acquisition using linux dvsdk from
> > Texas Instruments or any linux on beagleboard
> >
> >
> > Please help
> >
>



--
Thanks & Regards
Nidhi Mittal Hada
Scientific officer D
Computer Division
Bhabha Atomic Research Center
Mumbai

http://nidhi-searchingmyself.blogspot.com/
