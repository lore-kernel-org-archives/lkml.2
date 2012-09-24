Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab2IXGgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:36:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20542 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2IXGgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:36:50 -0400
Date: Mon, 24 Sep 2012 09:36:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: yvahk-xreary@zacglen.net
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Steven Toth <stoth@kernellabs.com>,
        Devin Heitmueler <dheitmueller@kernellabs.com>,
        Mijhail Moreyra <mijhail.moreyra@gmail.com>
Subject: Re: Freeze or Oops on recent kernels
Message-ID: <20120924063641.GB28937@mwanda>
References: <201209071124.q87BODFm028421.zacglen.com@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209071124.q87BODFm028421.zacglen.com@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not going to file a bug for this on bugzilla because it's
ancient and not a new bug.  But I can forward it to linux-media
and the get_maintainer.pl people for cx23885_video.

HINT: We only care about the very most recent kernel.  If you can
take a photo of the stack trace, then file a bug report and attach
the .jpg.

regards,
dan carpenter

On Fri, Sep 07, 2012 at 09:24:13PM +1000, yvahk-xreary@zacglen.net wrote:
> 
> I am getting either a a kernel Oops or freeze (without any console output)
> on recent kernels.  I have tested on 2.6.32.26 PAE, 3.1.9 PAE, and 3.4.9 PAE
> all with similar results.
> 
> The hardware involved comprises mainly:
> 
> 	12 GB ram
> 	Intel DX58S02 motherboard
> 	Intel Xeon E5220
> 	2 x onboard ethernet
> 	Intel PRO/1000 PT Dual Port ethernet
> 	Hauppauge HVR1700 DVB-T PCIe card
> 	Technisat SkyStar2 DVB-T PCI card
> 
> The oops or freeze occurs when both DVB cards are recording
> simultaneously. With either card installed on their own there
> is never any problem.
> 
> I should also add that the exact same kernel and cards on
> a Gigabyte GA-P31-S3G motherboard + Intel Pentium 4 the problem
> NEVER occurs. So there may be a DX58S02/timing/interrupt issue.
> 
> When there is an oops it is like this (hand-transcribed
> from 2.6.32.26 PAE kernel):
> 
> c0789444	panic + 3e/e9
> 		oops_end + 97/a6
> 		no_context + 13b/145
> 		__bad_area_nosemaphore + ec/f4
> 		? do_page_fault + 0/29f
> 		bad_area_nosemaphore + 12/15
> 		do_page_fault + 139/29f
> 		? do_page_fault + 139/29f
> c078b54b	error_code + 73/78
> f82084fb	? cx23885_video_irq + d8/1dc
> f820b04d	cx23885_irq + 3df/3fe
> c04834ac	handle_irq_event + 57/fd
> 		handle_fasteoi_irq + 6f/a2
> 		handle_irq + 40/4d
> 		do_IRQ + 46/9a
> 		common_interrupt + 30/38
> c045b7a9	? prepare_to_wait + 14c
> f7fef5a5	? videobug_waitm + 90/133
> c045b601	? autoremove_waker_function + 0/34
> f805e5bc	videobuf_dvb_thread + 73/135
> f805e4f9	? videobuf_dvb_thread + 0/135
> c045b3c9	kthread + 64/69
> 		? kthread + 0/69
> 		kernel_thread_helper + 7/10
> 
> Although I am a very experienced programmer I have next to zero
> kernel expertise except for minor patching of a few drivers.
> 
> My guess from the stack trace is that there might be an issue
> with page fault recursion (if that is at all possible).
> 
> Anyhow I don't want to waste too much of my time or anybody elses
> on this - although with the problem occuring with 3.4.9 kernel which
> has significant interrupt handling changes it probably is something
> that somebody might want to know about. If anybody can spot a clue
> as to where I should be looking and how I should go about isolating
> the problem (if only kernel core dumped!) please let me know and
> I will possibly try and assist. I need some guidance.
> 
> Regards
> John W.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
