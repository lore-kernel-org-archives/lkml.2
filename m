Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab1DZVGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:06:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51132 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab1DZVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:06:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
	<20110419171340.GE6640@elte.hu> <20110419173521.GA25374@aftab>
	<20110419174446.GA13616@elte.hu> <20110420102349.GB1361@aftab>
	<m1hb9mnmqs.fsf@fess.ebiederm.org> <20110426074238.GA22448@aftab>
Date: Tue, 26 Apr 2011 14:06:39 -0700
In-Reply-To: <20110426074238.GA22448@aftab> (Borislav Petkov's message of
	"Tue, 26 Apr 2011 09:42:38 +0200")
Message-ID: <m1y62wk9i8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+oHdtqOVdkuDWYp/sqPuLrzUGZ+zzffoM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@amd64.org> writes:

> On Mon, Apr 25, 2011 at 03:40:11PM -0400, Eric W. Biederman wrote:
>> > From: Borislav Petkov <borislav.petkov@amd.com>
>> > Date: Wed, 13 Apr 2011 14:32:06 +0200
>> > Subject: [PATCH -v2.1 2/2] x86, MCE: Drop the default decoding notifier
>> >
>> > The default notifier doesn't make a lot of sense to call in the
>> > correctable errors case. Drop it and emit the mcelog decoding hint only
>> > in the uncorrectable errors case and when no notifier is registered.
>> > Also, limit issuing the "mcelog --ascii" message in the rare case when
>> > we dump unreported CEs before panicking.
>> >
>> > While at it, remove unused old x86_mce_decode_callback from the
>> > header.
>> 
>> Can we please print something if we please log something in the
>> case of a correctable error, when we only report it via mcelog?
>> 
>> I have a stupid recent intel cpu here that hits that case and without
>> the default x86_mce_decode_callback I wouldn't have even known that I am
>> getting something like 50 correctable errors an hour on one of my
>> machines.  In particular I am it hits so often I am seeing:
>> "mce_notify_irq: 2 callbacks suppressed".  I need to get those dimms
>> replaced soon because in a new product I simply can't imagine that many
>> correctable errors.
>
> Isn't there a mcelog daemon or something that polls /dev/mcelog and
> tells you about those DRAM ECCs in some log file where you're supposed
> to look? :)

On fedora 14 there is a cron job that writes to /var/log/mcelog, and
does not go through syslog.  But you have to be proactive and look
there.  If the people who work on this code can't even remember
where to look I can't imagine how anyone else can remember.
Which is why I object to the removal of the one printk that told
me something was broken on my machine.

So far from what I have seen /dev/mcelog and the userspace mcelog is
over complicated and near useless.  It seems to focused around the
notion that "This is not a software problem, please do not bug
Andi Kleen about it"

Well it is a hardware problem so I do need to RMA that hardware.
Sigh.

Eric

