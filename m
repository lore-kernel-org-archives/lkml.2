Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab0I0VRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:17:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0I0VRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YwNSzqfYzgUaEQKtzxC7riPHNCf8ZsaqIn0oC9CSC9JGrSiTrZ9yw9kKcN2P0XrlGs
         JU/wEQ4D5Ui4hHf511khmexWODY3DyIT8Mk3hdDxR7QCrBaBNKtHylojcizQ2WsThQSV
         bnRdSeJMB4WxYd0pKRLpnDF1GC+EW9duW5WHc=
Subject: Re: [PATCH] si time accounting accounts bh_disable'd time to si
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTim2=ZN=DMFCYcvVx31mOPd40q+EoTVfx-bqMCob@mail.gmail.com>
References: <1285003599.2275.756.camel@laptop>
	 <1285619753-10892-1-git-send-email-venki@google.com>
	 <1285620805.2512.128.camel@edumazet-laptop>
	 <AANLkTim2=ZN=DMFCYcvVx31mOPd40q+EoTVfx-bqMCob@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 23:16:09 +0200
Message-ID: <1285622169.2512.135.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 27 septembre 2010 à 14:11 -0700, Venkatesh Pallipadi a écrit :
> On Mon, Sep 27, 2010 at 1:53 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > But softirq handlers sometime call functions that might disable bh
> > again. It would be good to not switch softirq time to system time ;)
> 
> Yes. Good point :-). I should rather have
> +#define in_serving_softirq() (softirq_count() & SOFTIRQ_OFFSET)
> 
> >
> > Shouldnt we reserve a bit (high order bit out of 8) instead ?
> >
> >  * PREEMPT_MASK:    0x000000ff
> >  * SOFTIRQ_MASK:    0x0000ff00
> >  * SERVING_SOFTIRQ: 0x00008000
> >  * HARDIRQ_MASK:    0x03ff0000
> >  *     NMI_MASK:    0x04000000
> 
> Things will be very much similar using higher order bit or lower order
> bit. Somehow I felt using lower order bit was cleaner...
> 

No problem, I now undertand what you wanted to achieve ;)



