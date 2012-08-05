Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2HEIXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:23:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47706 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2HEIXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:23:50 -0400
Date: Sun, 5 Aug 2012 11:23:37 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: artem.bityutskiy@linux.intel.com, Tim Bird <tim.bird@am.sony.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Subject: Re: UBI fastmap updates
Message-ID: <20120805112337.2a315c75@pixies.home.jungo.com>
In-Reply-To: <20120802194538.26e2ec98@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
	<20120802183210.7076aa48@spider.haslach.nod.at>
	<1343925930.25013.163.camel@sauron.fi.intel.com>
	<501AB2C8.9010805@am.sony.com>
	<1343929200.25013.197.camel@sauron.fi.intel.com>
	<20120802194538.26e2ec98@spider.haslach.nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2 Aug 2012 19:45:38 +0200 Richard Weinberger <richard@nod.at> wrote:
> Okay, then let's explicitly reserve a few PEBs for fastmap.
> This should be very easy task.

Need to consider what's expected when migrating from a former non-FM
UBI system to an FM enabled system, in the case where all PEBs where
consumed (reserved) in the former system.

> How much PEB should be reserved? 2 x sizeof(fastmap)?

Since FM does not use EBA's atomic LEB change when writing the new
fastmap, but instead implements its own FM "leb change" internally -
then reserving 2x is needed if we'd like to avoid reusing the same
fastmap PEB.

Regards,
Shmulik
