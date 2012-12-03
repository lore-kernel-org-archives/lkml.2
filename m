Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab2LCXOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:14:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54414 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2LCXOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:14:21 -0500
Message-ID: <50BD3244.900@linaro.org>
Date: Mon, 03 Dec 2012 15:14:12 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Heinz Wiesinger <HMWiesinger@gmx.at>
CC: Greg KH <gregkh@linuxfoundation.org>, Jonathan Nieder <jrnieder@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>, rtc-linux@googlegroups.com
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the hardware
 (v2)
References: <20120330195823.GA31857@kroah.com> <20121105091118.GA12721@elie.Belkin> <20121105101331.GA24688@kroah.com> <1672482.cmtUloFutg@callisto>
In-Reply-To: <1672482.cmtUloFutg@callisto>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120323-7182-0000-0000-0000037F0EBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:55 PM, Heinz Wiesinger wrote:
> On Monday 05 November 2012 11:13:31 Greg KH wrote:
>> On Mon, Nov 05, 2012 at 01:11:18AM -0800, Jonathan Nieder wrote:
>>> Hi,
>>>
>>> In March, Greg KH wrote:
>>>> 3.2-stable review patch.  If anyone has any objections, please let me
>>>> know.
>>> Sorry, I'm a little late.  This seems to be causing spurious wakeups
>>> after shutdown on some systems just like v1 did. :/
>>>
>>> Janne Boman reports[1], using an HP EliteBook 8530w:
>>> | I'm unable to shutdown my system via normal means. The system
>>> | completes the shutdown process, all hardware lights are off, but then
>>> | somehow it restarts.
>>>
>>> Based on a quick web search, Heinz Wiesinger, using the same model,
>>>
>>> ran into the same problem and bisected it to this patch:
>>>    https://bugzilla.kernel.org/show_bug.cgi?id=44261
>>>
>>> Janne confirmed the same by testing kernels closely based on 3.2.13
>>> and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
>>> now" behaved roughly speaking like "reboot".  A kernel close to 3.6.4
>>> was also affected.
>> So is 3.6.6 still and issue?  How about 3.7-rc4?  3.4.18?  Figuring out
>> if this is still an issue in Linus's tree would be the best thing to do
>> first.
> I checked 3.7-rc4 and the issue is still there. Should I still test the other
> versions as well? I can do so but it might take a bit.
>
> If you need anything else, I'll be happy to help wherever I can.

Hey Heinz,
   Sorry for being slow to respond to this, I was on leave when it 
arrived, and it got buried under other items.

This is peculiar.  I'm guessing something quirky with your hardware is 
causing the alarm irq to trigger shortly after we supposedly disable it. 
Could you send me your dmesg and kernel config?

After that I'll likely have to send you some debugging instructions 
(commenting out various lines) to try to figure out what exactly is 
triggering it.

Sorry for the trouble!

thanks
-john



