Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1ARNrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:47:35 -0500
Received: from nerdhammel.gnuher.de ([88.198.0.170]:40473 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1ARNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:47:34 -0500
Date: Tue, 18 Jan 2011 14:47:21 +0100
From: Matthias Merz <linux@merz-ka.de>
To: Brian Gerst <brgerst@gmail.com>
Cc: Matthias Merz <linux@merz-ka.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression in linux 2.6.37: failure on remount / (ext4) rw
Message-ID: <20110118134721.GA20840@merz.inka.de>
References: <20110110223154.GA9739@merz.inka.de> <AANLkTi=hnWtpHgv-j0u3n5sG4T-GU0KG_vAMe4vevY05@mail.gmail.com> <20110111130959.GA19003@merz.inka.de> <AANLkTimViOqKP9aw28PVt0_2LcH_OuruS736fickb_jp@mail.gmail.com> <20110114140458.GA7558@merz.inka.de> <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -0.0
X-Spam-Report: No, score=-0.0 required=5.5 autolearn=ham
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0269]
	*  1.1 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello together,

Am Mo, 17.01.2011 07:32 schrieb Brian Gerst
> On Fri, Jan 14, 2011 at 9:04 AM, Matthias Merz <linux@merz-ka.de> wrote:
> > git bisect now told me "22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1 is the
> > first bad commit", which is titled: "x86-32: Allocate irq stacks
> > seperate from percpu area".
> > I reverted this change (and following 47f19a0814 due to #defines) and
> > waited over the night until this morning. That revert really seems to
> > fix my problem. So maybe in my special case something goes wrong with
> > the new method?
> 
> Does this patch fix the problem?
> 
> Subject: [PATCH] x86: Clear irqstack thread_info
> 
> Make sure that the thread_info part of the irqstack is initialized
> to zeroes.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>


Yes, I tried booting three times with that patch enabled, the last time
this morning after power-down over night; all seems fine so far.
Thank you very much for the prompt fix!


Yours
Matthias Merz

-- 
"I hope to die before I *have* to use Microsoft Word."
     - Donald E. Knuth, 2001-10-02 in Tübingen.
