Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1EXHi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:38:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:47029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1EXHix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:38:53 -0400
Subject: Re: [PATCH v3] x86, vt-d: enable x2apic opt out
From: David Woodhouse <dwmw2@infradead.org>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>
Date: Tue, 24 May 2011 08:38:47 +0100
In-Reply-To: <17321.1306210686@localhost>
References: <1306161148-3987-1-git-send-email-youquan.song@intel.com>
	 <7457.1306203521@localhost>
	 <20110524153614.GA19080@linux-youquan.bj.intel.com>
	 <17321.1306210686@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306222728.2627.49.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 05:18 +0100, Valdis.Kletnieks@vt.edu wrote:
> Do we want an actual WARN there, complete with stack traceback and
> all?
> 
> Or did you intend a pr_warn or printk(KERN_WARNING or similar?

The traceback has been very useful in other BIOS issues, because it gets
tracked and counted on kerneloops.org along with platform
identification. So we have been able to track down the major offenders
of some of the most egregious BIOS stupidities and make *some* progress
on getting them to improve the untested dross they habitually turn out.

On *this* occasion perhaps a printk might suffice. After all, this
X2APIC_OPT_OUT was invented specifically as a way to allow the BIOS
engineers to get away without fixing their bugs. But then again, it
would also be useful to track how many people are doing it, and I cannot
think of a *legitimate* reason for a BIOS having to set it. So on
balance I'm happier with the WARN().

-- 
dwmw2

