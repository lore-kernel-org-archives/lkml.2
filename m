Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab1IOPXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:23:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38234 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934018Ab1IOPXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:23:36 -0400
Message-ID: <4E721871.7040901@lwfinger.net>
Date: Thu, 15 Sep 2011 10:23:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "'Chaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: 3.1-rc6+ rtl8192se issue
References: <20110915124406.GA14374@gere.osrc.amd.com>
In-Reply-To: <20110915124406.GA14374@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 07:44 AM, Borislav Petkov wrote:
> Hi Larry,
>
> I'm experiencing an issue with rtl8192se since 3.1-ish timeframe where
> the machine becomes completely unresponsive and only a reboot helps
> the situation. I think the issue has to do with the rtl8192se wireless
> driver because if I connect the machine through ethernet, it runs pretty
> smoothly.
>
> Today, I left the machine on the vt console in the expectation of an
> oops or something to appear in the logs and logged into it from another
> machine over ssh.
>
> After a while, the unresponsiveness happened and the box didn't
> react to keyboard input except sysrq with which I was able to do the
> show-backtrace-all-active-cpus(L) thing and attached is a partial
> screen cap of that. It looks like the stuck-up happens somewhere in
> rtl_lps_leave() along the rtl92s_phy_set_rf_power_state() path but the
> register dump is missing with the exact %rIP.
>
> Anyway, pls take a look and let me know if it rings any bells. I'll
> continue trying to debug the issue, maybe I should bisect it if nothing
> else pops up.

Borislav,

Thanks for the report. I have been running rtl8192se for the past few days and I 
have also noticed two such system freezes, but not been able to capture any 
info. As I have recently made many changes in my system recently, I did not know 
what might be the cause, but rtl8192se is certainly on the suspect list.

I have added Chaoming Li to the Cc list. I will send him the screen photo 
separately.

Some questions:

I expect that you are running a mainline kernel from Linus's tree. If not, 
please let me know. Mine is 3.1-rc4 from the wireless-testing tree. I don't 
recall any changes in out "next-flavored" version that are not in 3.1.

Which flavor of RTL8192SE card do you have? The one I'm running shows as 
"Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] 
(rev 10)", but I have two others. The differences are in the number of TX and RX 
streams. Mine is the 1x2 variety.

How frequently do your freezes occur? As I said before, I have only had two in 2 
or 3 days, which would make bisection tricky.

I see from the dump that you have x86_64 architecture. How many CPUs and how 
fast? There is one questionable report of problems on a box with an 8-way fast 
processor. That was on initialization and is not the same, but may indicate a 
problem. My system has a dual AMD CPU at 2.0 GHz.

Would you also try loading rtl8192se with the "ips=0" option? As power save is 
implicated in your traceback, that may help. I will be trying "swlps=0 ips=0".

Thanks for the report,

Larry
