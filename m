Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1FFXGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:06:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10774 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1FFXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:06:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:user-agent:x-system-of-record;
	b=ROg9AkmrPBj3JDS7YK5ny74jPS7HlxHWMgQZzkEvpZDh3j02VGQ+tvA1qeB3flct4
	OsHQoJBfpGW9CfhHmT+dQ==
Date: Mon, 6 Jun 2011 16:05:22 -0700
From: Todd Poynor <toddpoynor@google.com>
To: Kevin Hilman <khilman@ti.com>
Cc: l-o <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
Message-ID: <20110606230522.GA16590@google.com>
References: <1307214239-16316-1-git-send-email-ccross@android.com>
 <BANLkTingmUNvZO_szivRkmn7LRO4L5A+5Q@mail.gmail.com>
 <87r576wpz6.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r576wpz6.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:32:29PM -0700, Kevin Hilman wrote:
> Colin Cross <ccross@android.com> writes:
> 
> > On Sat, Jun 4, 2011 at 12:03 PM, Colin Cross <ccross@android.com> wrote:
> >> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
> >> causing only the last bit set to take effect, resulting in lost
> >> wakeups when the GPIO controller is in idle.
> >>
> >> Replace direct writes to IRQWAKEN with writes to SETWKUENA and
> >> CLEARWKUEN.
> >>
> >> Signed-off-by: Colin Cross <ccross@android.com>
> 
> [...]
> 
> >
> > Todd pointed out that the OMAP4 TRM says not to use SETWKUENA and
> > CLEARWKUENA.  
> 
> In my GPIO cleanups, I was wondering why the set/clear registers were
> not used here. Todd, can you give the TRM version & reference for this?
> I didn't find anything after a quick scan/search.

http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?templateId=6123&navigationId=12037

OMAP4460 Multimedia Device Silicon Revision 1.0 Version E
February 2011–Revised May 2011

p. 5357 Table 25-68. GPIO_CLEARWKUPENA

"Caution: This register is kept for backward software compatibility. Use
GPIO_IRQWAKEN_0 and GPIO_IRQWAKEN_1 instead."

OMAP4430 TRM is similar.


Todd
