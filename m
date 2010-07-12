Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0GLVyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:54:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42697 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab0GLVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:54:04 -0400
Message-ID: <4C3B8E94.6040101@zytor.com>
Date: Mon, 12 Jul 2010 14:52:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Bodo Eggert <7eggert@web.de>, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <f5czp-42V-9@gated-at.bofh.it> <f5n1M-2lt-21@gated-at.bofh.it> <f5tqz-3ll-37@gated-at.bofh.it> <f5u3g-4mj-11@gated-at.bofh.it> <f5v90-5Wo-7@gated-at.bofh.it> <20100712211459.A0644107B09@mail-in-07.arcor-online.net>
In-Reply-To: <20100712211459.A0644107B09@mail-in-07.arcor-online.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 01:57 PM, Bodo Eggert wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/12/2010 09:21 AM, Yinghai Lu wrote:
> 
>>> earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
>>> because it is shared between different archs already.
> 
>> console= is crap, because it makes the user keep track of items they
>> should not have to deal with directly (unless they want to override the
>> defaults), i.e. the specific I/O ports used by the serial ports.
> 
> Why does console= require these parameters, if earlyprintk does not?
> 
> IMO you should fix console= to not need these parameters unless they cannot
> be guessed (in which case earlyprintk cannot guess them, either).
> 

earlycon is basically a low-level interface where you can steer
everything.  This is what you have to do on most embedded architectures,
where the firmware doesn't tell you where the console is located.

On x86, either the firmware can tell you or you can rely on 20 years of
legacy, with very few divergences.

	-hpa

