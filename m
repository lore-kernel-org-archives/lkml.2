Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672Ab1IOTqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:46:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934628Ab1IOTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:46:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+/Lf5hFRO/IfanADZAyNu/cjSWqWwbddpN4TbEJS
	hU1n8hG3XChzzv
Message-ID: <4E72561C.7060603@gmx.de>
Date: Thu, 15 Sep 2011 19:46:36 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Keith Packard <keithp@keithp.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark\, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
References: <1316088425.11294.78.camel@lappyti>	<yunboul7sx7.fsf@aiko.keithp.com>	<1316100594.23214.65.camel@deskari>	<yun8vpp7qk7.fsf@aiko.keithp.com>	<4E72320B.6020000@gmx.de>	<20110915181802.69ef0d56@lxorguk.ukuu.org.uk>	<4E723A20.2040002@gmx.de> <20110915200514.74bdcd90@lxorguk.ukuu.org.uk>
In-Reply-To: <20110915200514.74bdcd90@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 07:05 PM, Alan Cox wrote:
>> What is your problem with discontigous framebuffers? (I assume discontigous
>> refers to the pages the framebuffer is composed of)
>> Sounds to me like you should implement your own fb_mmap and either map it
>> contigous to screen_base or implement your own fb_read/write.
>> In theory you could even have each pixel at a completely different memory
>> location although some userspace wouldn't be happy when it could no longer mmap
>> the framebuffer.
> 
> The mmap side is trivial, the problem is that the fb layer default
> implementations of blits, fills etc only work on a kernel linear frame
> buffer. And (for example) there is not enough linear stolen memory on
> some Intel video for a 1080p console on HDMI even though the hardware is
> perfectly capable of using an HDTV as its monitor. Nor - on a 32bit box-
> is there enough space to vremap it.

Okay, I see your problem. It's a bit strange you don't have acceleration. I
guess you need either your own implementation of those or adding function
pointers like fb_read/write just without the __user and use those instead of
direct memory access in the cfb* implementation if screen_base is NULL. Does not
sound like a big problem to me, but pretty inefficient, so probably copying the
existing ones and adjusting it to your needs would be preferred (just like the
sys* implementations exist).


Best regards,

Florian Tobias Schandinat
