Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab0JFSpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:45:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:45641 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690Ab0JFSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:45:02 -0400
Message-ID: <4CACC3A0.4090300@windriver.com>
Date: Wed, 06 Oct 2010 13:44:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>	<20100921151033.80e61747.randy.dunlap@oracle.com>	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>	<4C9A1FB7.9050902@oracle.com>	<19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>	<19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>	<20100923080212.ca4be1f6.rdunlap@xenotime.net>	<19611.32996.817920.499437@elektron.ikp.physik.tu-darmstadt.de> <20100924080707.ba98fa1e.rdunlap@xenotime.net>
In-Reply-To: <20100924080707.ba98fa1e.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 18:44:49.0841 (UTC) FILETIME=[8E58FA10:01CB6586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 10:07 AM, Randy Dunlap wrote:
> On Thu, 23 Sep 2010 18:31:32 +0200 Uwe Bonnes wrote:
>
> [just adding cc's]
>
>   
>>>>>>> "Randy" == Randy Dunlap <rdunlap@xenotime.net> writes:
>>>>>>>               
>>     Randy> Is CONFIG_DRM_KMS_HELPER enabled in your kernel .config file?  If
>>     Randy> not, we need to find out how to enable it (there is no kconfig
>>     Randy> prompt for it).
>>
>> Yes, it is enabled
>>
>>     Randy> Can you check if Alt-Sysrq-H (help) lists V for "force-fb(V)"?
>> Yes, it is listed.
>>
>> And yes, my last experiments where with ALT-CTL-sysreq, so doomed for non
>> function due to operator error.
>>
>> However:
>> When running X, X.Org X Server 1.9.0 on Thinkpad R50 RV250, Alt-Sysrq-v
>> switches to an all-black display. By console switching with ALT-CLT-F1 I
>> get back to the booting console and ALT-CLT-F7 brings me back to X.  Running
>> on the console and calling Alt-Sysrq-v prints
>>  SysRq : Restore framebuffer console
>>
>> Is there some omission by the distribution or my setup that Alt-Sysrq-v when
>> running X results in an all-black screen?
>>
>> And when I hit the hibernate problem, the screen stays black even with a
>> console switch after Alt-Sysrq-v
>>
>>     
I am not exactly sure what you are looking for but alt-sysrq-v might not
tell you a whole lot because an escape back to the text console that was
not actively receiving printk's or crash data is going to in general
provide you with a black screen.

If you were interested in something a bit more invasive such as a
collecting a process listing or examining the dmesg output you might
consider jumping into kdb.  

echo kbd > /sys/module/kgdboc/parameters/kgdboc

Then you would do the "alt-sysrq v" followed by "alt-sysrq g".  From
there you could then run dmesg, and your screen would no longer be blank
in theory.  :-)

We do have some patches for the RV250 for atomic kernel mode setting
plus kdb support but they are not merged to the mainline kernels as of yet.


Jason.
