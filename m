Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1K2Nqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:46:42 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59417 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1K2Nql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:46:41 -0500
MIME-Version: 1.0
In-Reply-To: <4ED4D398.3070506@gmail.com>
References: <4ED4BD22.3070003@f-secure.com>
	<4ED4D398.3070506@gmail.com>
Date: Tue, 29 Nov 2011 08:46:40 -0500
Message-ID: <CA+5PVA4XP08T+soQ+2ArJWE2CWuvVK4Q4UTJ8+kYyVw=tfLtsw@mail.gmail.com>
Subject: Re: [BUG] uvcvideo is broken on Linux-3.2-rc3
From: Josh Boyer <jwboyer@gmail.com>
To: Rares Aioanei <krnl.list@gmail.com>
Cc: Tarkan Erimer <tarkan.erimer@f-secure.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 7:44 AM, Rares Aioanei <krnl.list@gmail.com> wrote:
> On 11/29/2011 01:08 PM, Tarkan Erimer wrote:
>>
>> Hi,
>>
>> When I initiate any webcam software like Cheese, Kamoso, skype etc. I'm
>> having the below message at dmesg :
>>
>> [ 1171.856931] uvcvideo: Failed to submit URB 0 (-28).
>> [ 1191.728944] uvcvideo: Failed to submit URB 0 (-28).
>> [ 1191.728959] uvcvideo 1-1.5:1.1: resume error -28
>
> I can confirm this with a Microsoft LifeCam webcam and kernel
> 3.2.0-rc3-00023-g401d006.

This was narrowed down to:

USB: EHCI: fix HUB TT scheduling issue with iso transfer (811c926c5)

I believe.  That patch has been reverted from the 3.1.x stable series
due to a similar bug report there.

josh
