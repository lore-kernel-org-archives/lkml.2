Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1I0SPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:15:04 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:59543 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1I0SPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:15:01 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Sep 2011 14:15:01 EDT
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzzz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E820E4D.5050205@am.sony.com>
Date: Tue, 27 Sep 2011 10:56:29 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 04:03 PM, Simon Glass wrote:
> This experimental patch set adds boot timing to a Linux system. The
> timing starts with the boot loader and extends through the kernel into
> user space to the completion of the boot process. The timing starts when
> the system leaves reset, not later when the kernel starts.

I would be very interested in this.  This is something that
would be very helpful, I believe, to assist with optimizing
overall boot time.

> Finally, in user space there is no kernel-blessed way to record
> timestamps. One approach is to add lines to the init scripts like
> 'cat /proc/uptime >/tmp/login_starts'.
> This creates another place where
> the boot timing tool must look for information.

'cat /proc/uptime >/dev/kmsg' (with printk timestamps on) is much
better than the above, for this reason.

> This Patchset
> -------------
> This patchset aims to unify timing in one place: a simple driver which
> collects pre-kernel boot timestamps, adds its own as it boots, with
> calls to bootstage_mark(), then allows user space (init, etc.) to add
> more with 'echo "message" >>/sys/kernel/debug/bootstage/mask'.
>
> Finally it permits user space to access the full list of timestamps
> with 'cat /sys/kernel/debug/bootstage/report', which has two columns:
> the stage name and the timestamp:
>
> 	reset	0
> 	arch_cpu_init-AVP	258902
> 	arch_cpu_init-A9	263267
> 	arch_cpu_init-done	263312
> 	board_init_f-start	263314
> 	board_init_r-start	323671
> 	main_loop	573008
...

I would prefer the timestamp in the first column.  Also, for consistency
it would be good if it used the same format as printk timestamps:
"[%5lu.%06lu]" with seconds and micro-seconds in the respective fields.
Then, existing tools like scripts/show_delta and scripts/bootgraph.pl
could work on this data as well.

Full micro-second granularity is not required, but it's nice to keep
the format the same, whether the clock supports it or not.

Finally, is this work related at all to this:
http://lists.denx.de/pipermail/u-boot/2011-September/099996.html
Bootgraph.pl instrumentation support for UBoot
??

Just wondering.

Thanks - this looks like great stuff!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

