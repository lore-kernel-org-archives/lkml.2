Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1FZVnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:43:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:37080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab1FZVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:43:07 -0400
Date: Sun, 26 Jun 2011 14:47:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: pradeep hettiarachchi <pradeepmh@wayne.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CPU Instantaneous Power Consumption
Message-ID: <20110626144742.2f6ae3ef@infradead.org>
In-Reply-To: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com>
References: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 22:15:47 -0400
pradeep hettiarachchi <pradeepmh@wayne.edu> wrote:

> Hi,
> 
> I am a PhD student and doing a research which involves
> control-theoretic real-time process/job scheduling. Here is my
> question:
> 
> I need to calculate the power consumption of a single or two CPU cores
> and equivalent Thermal Dissipation accurately. I did not find any
> supporting material from Intel to find the instantaneous power
> consumption (and thermal dissipation) of the CPU. Therefore I am
> trying some alternative path; I measure the CPU regulator input
> current (using a very small shunt resister in series with 4 pin CPU
> ATX connector). Also, assuming that the CPU voltage regulator operates
> at 12 V rated, I could calculate the input power to the CPU regulator.
> 
> However without knowing the following I cannot complete my power
> calculation:
> 
> 1) What is the DC-to-DC CPU regulator efficiency ?

tends to be pretty high, but it's also very dependent on the load; it's
not a constant, but it's a curve depending on the output load

> 2) What is the relationship between TDP and input power to the CPU ?

there isn't one.
TDP is the power the CPU will use under a "power virus" like workload,
eg this is the number that a system vendor is expected to be able to
cool.

What you actually use on a real life workload is less than that... how
much less "depends"

> 3) Do you suggest any other better method to calculate the
> instantaneous input power to the CPU ?

define "instantaneous"....
if you care about "100 milliseconds" resolution, sure you can do that.
if you want to do nanosecond kind of resolution (couple of hundred
instructions) it gets much more tricky, since the CPU will act as a
very big capacitor as well (as do other parts of the system); all will
smooth out current and voltage changes... limiting your visibility
resolution (think of it acting as a low pass filter)

>  (I can think of calculating accurate instantaneous CPU power as VID
> (corresponding Vcc) x CPU_current_from_regulator; but, how do I read
> instantaneous VID ? Is there any MSR that I can instantly access to

the VID is not the instantaneous voltage. It's a minimum voltage a CPU
requests from the VR's.... what you actually get is much more variable
and depends also on current spikes/drops.
To calculate power you need to multiple the actual instantaneous
voltage by the instantaneous current..... and then all you get is the
power going into the capacitor .. not the "power dissipated" number.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
