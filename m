Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1DGNAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:00:20 -0400
Received: from core.signal11.us ([64.251.29.136]:37354 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1DGNAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:00:18 -0400
Message-ID: <4D9DB560.7000200@signal11.us>
Date: Thu, 07 Apr 2011 09:00:16 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: linux-next: build failure after merge of the hid tree
References: <20110407110626.397202fb.sfr@canb.auug.org.au>
In-Reply-To: <20110407110626.397202fb.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Apr  7 09:00:17 2011
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 4d9db561189409355917481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 09:06 PM, Stephen Rothwell wrote:
> After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> samples/hidraw/hid-example.c: In function 'main':
> samples/hidraw/hid-example.c:103: warning: implicit declaration of function 'HIDIOCSFEATURE'
> samples/hidraw/hid-example.c:111: warning: implicit declaration of function 'HIDIOCGFEATURE'
> tmp/ccK96SHd.o: In function `main':
> hid-example.c:(.text+0x205): undefined reference to `HIDIOCSFEATURE'
> hid-example.c:(.text+0x23e): undefined reference to `HIDIOCGFEATURE'
>
> Caused by commit c54ea4918c2b ("HID: Documentation for hidraw").  I can
> only assume that linux/hidraw.h is being included from /usr/include and
> not the kernel tree being built?

Hi Stephen,

That sounds like a reasonable explanation. What's the right way to do
this? I suppose I had incorrectly assumed that the include path would be
set by the build system to the kernel tree being built. The other
samples seem to do the same thing (simply #including whatever they
need), and don't seem to do anything special with include paths to make
it use the current tree.

Maybe Randy can shed some light.

Sorry for the bother,

Alan.



