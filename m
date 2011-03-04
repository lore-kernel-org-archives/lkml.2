Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab1CDG5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:57:23 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:38591 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab1CDG5W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:57:22 -0500
From: Peppe CAVALLARO <peppe.cavallaro@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stuart MENEFY <stuart.menefy@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Fri, 4 Mar 2011 07:53:50 +0100
Subject: Re: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Thread-Topic: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Thread-Index: AcvaOOtaEfq/brCeRt6Ks9dBa2ETnA==
Message-ID: <4D708C7E.8010204@st.com>
References: <1298369864-24429-1-git-send-email-peppe.cavallaro@st.com>
 <201103030945.07486.arnd@arndb.de> <4D6F6C96.1010303@st.com>
 <201103031455.25089.arnd@arndb.de>
In-Reply-To: <201103031455.25089.arnd@arndb.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.14)
 Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
openpgp: url=wwwkeys.bri.st.com
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/2011 2:55 PM, Arnd Bergmann wrote:
>
> On Thursday 03 March 2011, Peppe CAVALLARO wrote:
> > This logic is already in the driver, indeed.
> > What I've seen on our embedded systems is that the
> > cost of RX interrupts is very hight and NAPI partially helps.
> > Typically, in an IP-STB, I receive a burst of UDP pkt
> > and this  means that many interrupts occur (~99% of CPU
> > usage on slow platforms).
> > With the ext timer I was able to reduce the CPU usage in
> > these kind of scenarios to ~50%.
>
> I don't understand. Shouldn't the interrupts be stopped as long
> as the system is busy? This sounds like a bug in your NAPI
> handling, or maybe you just need to use a lower NAPI_WEIGHT
> so you stay in polling mode longer.
>

Hi Arnd,
yes you are right, in fact, I do not receive an interrupt
for each frame received but the average of the frames
I found in the ring is very low.
At any rate, let me do some tests so i'll come back with
some numbers. In the meantime, I'm looking at the napi
support inside the driver and experiment with lower
NAPI_WEIGHT (default is 64).

Peppe
>
>
>         Arnd
>
