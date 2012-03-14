Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab2CNUTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:19:47 -0400
Received: from rinux.net ([85.214.141.182]:50154 "EHLO rinux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab2CNUTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:19:32 -0400
Message-ID: <1331756331.5315.19.camel@erde.fritz.box>
Subject: RE: Kernel Panic with Rawtherapee (mce related)
From: Adalbert Dawid <dawid@rinux.net>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>
Date: Wed, 14 Mar 2012 21:18:51 +0100
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F15B64BF0@ORSMSX103.amr.corp.intel.com>
References: <1331678930.11814.16.camel@erde.fritz.box>
	 <4F60B0E3.6020503@linux.vnet.ibm.com> <20120314155906.GA25286@aftab>
	 <3908561D78D1C84285E8C5FCA982C28F15B64BF0@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the quick reply.

On Wed, 2012-03-14 at 17:51 +0000, Luck, Tony wrote:
> > You're getting a bunch of machine checks, the last one of them being
> > fatal (Process Context Corrupt bit is set) causing the machine to panic.
> 
> PCC is set in all of them
> 
> > Tony will probably be able to help you further in decoding what exactly
> > those MC0_STATUS and MC5_STATUS values mean
> 
> Bank 5 ends in 0400 - which means "Internal timer error". Bank 0 has 0800
> which is a bus/interconnect error where this processor was the source of
> a memory transaction.
> 
> That's where the facts end - speculation begins here ...
> 
> Since this is repeatable under load - it's possible that a page table got
> corrupted and you are trying to access some non-existent memory location?
> Do all traces for this panic involve *_tlb_* functions?

Since the screenshot I had posted is the only one I have been able to
capture, I don't know. I will try to provoke the crash by setting the
machine under load utilizing rawtherapee and will post results in case
of success. Cpuburn did not manage to crash the machine in a (shortish)
test I did a few days ago.

It would be very helpful to disable the "reboot in 30 seconds" timeout.
Is that possible somehow?

> Or perhaps you have a cooling problem - and when stressed your cpu or
> memory is getting too hot?

I do not believe this is true as the cpu fan plus two case fans are
running fine and the sensors display cpu tempratures <60°C, even under
load.

Up to now, it has always been rawtherapee that crashed the machine. This
is why I thought it might possibly be some special cpu feature (an SSE
command or something) that happens to be broken in my cpu and that is
triggered only by rawtherapee and not by any other software. What is
your opinion on this theory? 

> -Tony
> 


