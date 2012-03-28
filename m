Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2C1Tjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:39:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab2C1Tjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:39:32 -0400
Message-ID: <4F7368F2.9090007@onlinehome.de>
Date: Wed, 28 Mar 2012 21:39:30 +0200
From: Martin Rogge <marogge@onlinehome.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
  linux kernel 3.3.0
References: <iIvLH-3cI-5@gated-at.bofh.it> <iIw53-3TH-15@gated-at.bofh.it> <iIL45-3H1-5@gated-at.bofh.it> <iJTsB-44L-1@gated-at.bofh.it>
In-Reply-To: <iJTsB-44L-1@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:O1SBMOSta9/W6H5jRvxxvFFWp1dNuQ4CyAIk8xYkC7d
 +LZ1Og9L8X/s6R1E/KEOvc7YaiCynmwpz7HRg4biNVzqmdFkqy
 D+lRCfhRqaGLMPu5uc1rlgB6o6waX7/zrUYlBuZ6Ym1VugDyjq
 al1dXxtSwqJaA/Y5lyrr9i4R0WgNyKbW+2dzMH+j25AUGxHJDH
 r7KD5ACpJaGl3rQuPHtI/cPNsw/gRsNAMaG9LtVTZclOwCuFhF
 B//G3DmuMiaDRTsivcw/7Vfm9cL5MkDISPMRF+WZ4jIVFsJSnx
 AvQ9yNMovLxKIXUQdgg2ZOSnNQOFPwXaqWZGdHr0HMJGceRkIR
 KiVZM5K1mxfv0Yon9Cn8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 07:20 AM, Heinz Diehl wrote:
> On 25.03.2012, Valdis.Kletnieks@vt.edu wrote:
>
>> I'va always wondered what people are using to measure interactivity. Do we have
>> some hard numbers from scheduler traces, or is it a "feels faster"?
>
> I guess it's a "feels faster", because it's the only thing that
> counts.

I think it's inherently difficult to find an objective measure for the 
"feeled" smoothness and interactivity of a desktop machine under load. 
The measuring process probably needs to reside outside the system under 
test and interpret the HDMI output. And control the mouse input.

On a side note, I maintain a little http server and found during testing 
that different servers respond differently to different schedulers. 
(Note this is about throughput, not interactivity, since this is about 
servers and throughput is so easy to measure.) The following is an 
unedited quote from the README:


"As an example look at the
following result reading 1000000 static files at concurrency level 100:

Kernel       Server             Keep-     Requests       Rate     Max.
Version                         Alive     per sec.                [ms]
----------------------------------------------------------------------
3.1.4        Apache/2.2.21       yes        25427        33388     265
3.1.4        lighttpd/1.4.29     yes        54741        68892       6
3.1.4        MrHTTPD/2.2.0       yes        88898       100888       5
3.1.4-ck2    Apache/2.2.21       yes        43760        57462      17
3.1.4-ck2    lighttpd/1.4.29     yes        49227        61652       6
3.1.4-ck2    MrHTTPD/2.2.0       yes       163158       185150       2

The throughput offered by MrHTTPD is three to four times higher than
Apache and Lighttpd. Result sets at higher concurrency continue this
trend, and at insane concurrency levels like 10000 or 20000 MrHTTPD is
the only responsive server remaining.

The other stunning fact proven by these figures is the significant
impact of the BFS CPU scheduler and other optimizations inherent in the
CK patch, leading to almost twice the throughput compared to the
vanilla kernel (which was btw configured to use the CFQ scheduler).
This is even more surprising as the design goal of the CK patch is
desktop interactivity rather than server throughput.

It is also noticable that a fully threaded design like MrHTTPD benefits
particularly well from the CK patch, whereas the event-driven design of
Lighttpd often seems to perform slightly better under the vanilla
kernel."
