Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1AVRHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 12:07:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1AVRHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 12:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=paCIwtyxA65aNyflYMFDT7gByCMsTTwNPD1vezz+7DBP5votrcoPi6JXntORHY/lbn
         Df6SbCwYApgMg/axHN1uoDta6xxtamWQcS/7vOpTjI6QVgasXyxKfyN3T/dFe+BxXMa9
         t14VFSy9W229BTbwYgQVu8cPHA5ssPI2j1SBM=
Message-ID: <4D3B0EC7.2090903@gmail.com>
Date: Sat, 22 Jan 2011 20:07:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: unexpected NMI-s in 2.6.82-rc2
References: <alpine.SOC.1.00.1101221747240.8498@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1101221747240.8498@math.ut.ee>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2011 06:52 PM, Meelis Roos wrote:
> In 2.6.83-rc2 (and in 2.6.37-07788-ge78bf5e but that was only tested 
> briefly) I get the following unexpected NIM-s during work (dpkg):
> 
> Uhhuh. NMI received for unknown reason 2d on CPU 0.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue
> 
> The reaseons are 2d and 3d. I have total 4 of them and total 4 
> performance monitoring interrupts as below. After the load dropped I 
> have not seen more of them.
> 
> Computer is P4 2.4, i845 chipset. 2.6.37 was fine.
> 
...

Hi Meelis, it seems the p4 pmu is guilty here. I suspect
if you pass nmi_watchdog=0 or nowatchdog in boot line this
eliminate (or rather shut down) the problem for you.

Though Don was reporting this problem as well (CC'ed) and
at moment we didn't find the key reason why it's happening.
The problem is under investigation stage.

-- 
    Cyrill
