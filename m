Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0IJNXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:23:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44198 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0IJNXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=wJrcQZoTEIVJHEhNrOsJVCNvRER/49yJckTvBplirfkVZAoPRD+CmWef41xC0/+90V
         wwFX+esdG20yEJKSgMCd2cgp9l7nadQxFe8vMaBvCyoQFyE+pbrHbcFKgRmkLH+wSffS
         m6Tnbx+qiV0ovU830zINC8r0Huthji5KjSH0g=
Message-ID: <4C8A3131.7030003@gmail.com>
Date: Fri, 10 Sep 2010 15:22:57 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9pre) Gecko/20100819 Lightning/1.0b2 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Nix <nix@esperi.org.uk>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix> <alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6> <4C89FD56.6060505@gmail.com>
In-Reply-To: <4C89FD56.6060505@gmail.com>
X-Enigmail-Version: 1.1.1
OpenPGP: id=DDEB1C43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/10 11:41, Jiri Slaby wrote:
> AFAIU, clocksource=jiffies shouldn't fix this issue. If that's the case
> we have another 2.6.32->2.6.33 regression (and I will report it
> separately). People report the system is unusable (sleepers are not
> woken), unless clocksource=jiffies, clocksource=tsc or nolapic_timer is
> used or a key pressed (i.e. some HW interrupt):
> https://bugzilla.novell.com/show_bug.cgi?id=579932
> (there is also a report with 2.6.35.3 vanilla)

I saw this first in v2.6.35-rc4. The symptom is that suddenly everything
stops and the only way to make things progress is to generate some events.
Apps that are waiting for a timeout aren't woken up unless you press a key
etc. After a few minutes (and lots of key presses ;) ) the machine usually
recovers, leaving no trace in logs.
It's a nasty bug to debug as there's no way to trigger it, at least here,
and it usually does not want to happen when you most want it to; took me
~week to strike a bios upgrade from the suspect list, another one to
exclude intel_idle and so on. Never got around to check 30a564be9d955,
which was on the list too, unfortunately. I'll bet it /is/ the cause, but
won't be able to confirm this for quite a while...

artur
