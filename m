Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2DIRxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:53:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38616 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab2DIRxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:53:45 -0400
Message-ID: <4F832203.1010104@zytor.com>
Date: Mon, 09 Apr 2012 10:53:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Miles Fidelman <mfidelman@meetinghouse.net>
CC: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        peter.chubb@nicta.com.au, michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net>
In-Reply-To: <4F831BD0.3010707@meetinghouse.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 10:26 AM, Miles Fidelman wrote:
> Thanks for the quick response.
> 
> Matthew Garrett wrote:
>> On Mon, Apr 09, 2012 at 11:39:32AM -0400, Miles Fidelman wrote:
>>
>>> 1. What's the logic behind this?  Why not enable a bios reboot for 64bit
>>> kernels?  Is there any reason why the machine_real_restart code wouldn't
>>> work just as well in 64bit mode?  Anybody know the history?
>> The bios reboot code requires you to reprogram the CPU to real mode. I
>> don't think there's any fundamental reason you can't do that from 64-bit
>> mode, but nobody's ever written that code.
> 
> That would explain it.  I guess there's a little bit of trickiness
> involved in setting things up before
> switching to real mode.
> 

Actually this code already exists; the difference is that we have to
return to 32-bit mode first.

	-hpa
