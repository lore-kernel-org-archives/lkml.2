Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1AKUCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:02:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58987 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1AKUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V8n/Fot47K9HIdwiKtuPh+HwlUizsfZhF9onTRSN2/TCNC0xF3binusNTgFVDOuAC4
         KC5T3cQb5+wotSVc8A4vQ/+jN03zKy4MxJvNNcs1JAT4BKfQcirW9JjaKtRXOveoGNQ8
         qIZgSU0T5qo3niZgLEbPOiOb5APoPFkq+6dek=
Date: Tue, 11 Jan 2011 12:01:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "'Pavel Machek'" <pavel@ucw.cz>, "jj@chaosbits.net" <jj@chaosbits.net>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110111200155.GA20631@core.coreip.homeip.net>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
 <20110110221624.GA16445@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
 <20110110230622.GB16759@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D03165A008062@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A008062@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:34:09AM -0800, Rakesh Iyer wrote:
> Hello All.
> 
> I have combined Pavel's and Dmitry's comments so I can address them as one issue.
> 
> Dmitry's comment
> 
> > On Mon, Jan 10, 2011 at 02:49:25PM -0800, Rakesh Iyer wrote:
> > > > On Fri, Jan 07, 2011 at 09:45:07AM -0800, riyer@nvidia.com wrote:
> > > > > +
> > > > > +struct tegra_kbc {
> > > > > +	void __iomem *mmio;
> > > > > +	struct input_dev *idev;
> > > > > +	int irq;
> > > > > +	unsigned int wake_enable_rows;
> > > > > +	unsigned int wake_enable_cols;
> > > > > +	spinlock_t lock;
> > > > > +	unsigned int repoll_time;
> > > > > +	unsigned long cp_dly_jiffies;
> > > > > +	int fifo[KBC_MAX_KPENT];
> > > > > +	const struct tegra_kbc_platform_data *pdata;
> > > > > +	int *plain_keycode;
> > > > > +	int *fn_keycode;
> > > >
> > > > There should not be separate keycodes for FN and normal kys - FN is just
> > > > a modifier, like SHIFT or CTRL or ALT are and shoudl be handled in upper
> > > > layers.
> > >
> > > We had the same thought regarding Function as a modifier akin to Shift, Ctrl an Alt.
> > > But this does not appear to be the case.
> > >
> > > This keyboard is used primarily for Laptop-like form factors where function keys are used
> > to overload the existing keys.
> > 
> > So it is same SHIFT.
> > 
> > > In addition the Fn key mappings aren't identical in different keyboard layouts.
> > 
> > 
> > Same as SHIFT - depending on layout used shifted KEY_1 produces either '!' or '1'.
> 
> The FN key modifiers are not identical to Shift Modifier. They map to
> totally different keys for this keyboard.  If you are suggesting that
> you weren't implying they map to the same thing, then I agree it can
> be treated as a modifier.

Yes, I meant that FN is _similar_ to SHIFT, I did not suggest that they
produce the same mapping.

> But the problem is the higher layers don't necessarily do so. 

It is just a matter of setting it up. The console has option for adding
modifiers, xkb as well so please use them. No need to push this task
into the kernel.

> The documentation I have read all suggest the Fn key isn't a valid
> modifier for the operating system,

Huh? Why not? It mabe not a standard modifier but to say that it is not
a valid one is a stretch.

> and that most keyboard hardware
> abstracts the Fn keypress and generates the modified key.

Some hardware, like keyboards in most laptops, does abstract FN key.
They do it by emitting completely different scancode. With such hardware
the fact that FN is depressed is completely undetectable to the OS.

Your case is different, FN is regular key to whuch you assign a special
meaning, like you do for SHIFT, CTRL. ALT and other modifiers. And just
like SHIFT, CTRL, ALT and others it should not be hardcoded in the
kernel.

Thanks.

-- 
Dmitry
