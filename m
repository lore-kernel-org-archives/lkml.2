Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab1DZHnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:43:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47842 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab1DZHnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:43:10 -0400
Date: Tue, 26 Apr 2011 09:42:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Message-ID: <20110426074238.GA22448@aftab>
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
 <20110419171340.GE6640@elte.hu>
 <20110419173521.GA25374@aftab>
 <20110419174446.GA13616@elte.hu>
 <20110420102349.GB1361@aftab>
 <m1hb9mnmqs.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hb9mnmqs.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 03:40:11PM -0400, Eric W. Biederman wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > Date: Wed, 13 Apr 2011 14:32:06 +0200
> > Subject: [PATCH -v2.1 2/2] x86, MCE: Drop the default decoding notifier
> >
> > The default notifier doesn't make a lot of sense to call in the
> > correctable errors case. Drop it and emit the mcelog decoding hint only
> > in the uncorrectable errors case and when no notifier is registered.
> > Also, limit issuing the "mcelog --ascii" message in the rare case when
> > we dump unreported CEs before panicking.
> >
> > While at it, remove unused old x86_mce_decode_callback from the
> > header.
> 
> Can we please print something if we please log something in the
> case of a correctable error, when we only report it via mcelog?
> 
> I have a stupid recent intel cpu here that hits that case and without
> the default x86_mce_decode_callback I wouldn't have even known that I am
> getting something like 50 correctable errors an hour on one of my
> machines.  In particular I am it hits so often I am seeing:
> "mce_notify_irq: 2 callbacks suppressed".  I need to get those dimms
> replaced soon because in a new product I simply can't imagine that many
> correctable errors.

Isn't there a mcelog daemon or something that polls /dev/mcelog and
tells you about those DRAM ECCs in some log file where you're supposed
to look? :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
