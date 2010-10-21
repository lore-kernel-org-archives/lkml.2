Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0JUTKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:10:51 -0400
Received: from 174-46-170-154.static.twtelecom.net ([174.46.170.154]:59077
	"EHLO edprlnx06.logicpd.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752971Ab0JUTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:10:49 -0400
Message-ID: <4CC09042.3000201@logicpd.com>
Date: Thu, 21 Oct 2010 14:10:58 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100908 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tim Nordell <tim.nordell@logicpd.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP: Modified omap_mux_init_signal() to take in
 const char *
References: <1287687041-22377-1-git-send-email-tim.nordell@logicpd.com>
In-Reply-To: <1287687041-22377-1-git-send-email-tim.nordell@logicpd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/21/10 13:50, Tim Nordell wrote:
> If one does the following line twice with the old code:
>
> omap_mux_init_signal("uart3_rts_sd.gpio_164", OMAP_PIN_INPUT);
> omap_mux_init_signal("uart3_rts_sd.gpio_164", OMAP_PIN_INPUT);
>
> the compiler optimizes the two const strings into one string
> internally in the compiler.  The old code would modify the string
> by inserting a NULL effectively making the second call become:
>
> omap_mux_init_signal("uart3_rts_sd", OMAP_PIN_INPUT);
>
> Since the code changes _all_ uart3_rts_sd signals over to this,
> it'll cause unknown behavior, as well as making it more
> difficult to track down the reason since the string
> "uart3_rts_sd" by itself may not actually exist in your
> normal mux initialization sequence.
>

Gah.  I just realized there was a patch in the linux-omap tree to do the
same thing.

http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commitdiff;h=5a3b2f7a5a79082dd3a5f2294cbd85fc3b173d98;hp=7ad0e386d46e9edff64705ab25337ad9130baf63

It looks like by inspection that there could be a couple of things wrong
with that patch however.  Namely, on the comparison of muxname to
m0_entry, if they have the same string up to mode0_len, such as
"dss_data1" and "dss_data12" it'd match there prematurely as it'd stop
comparing.  Also, a minor display issue on the printk of the new muxname.

- Tim
