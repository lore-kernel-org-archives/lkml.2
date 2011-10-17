Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1JQMrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:47:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42381 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1JQMrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:47:07 -0400
Date: Mon, 17 Oct 2011 13:46:47 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-ID: <20111017124647.GA12838@srcf.ucam.org>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
 <20111017032232.GA4816@srcf.ucam.org>
 <4E9BBB6D.4050004@linux.intel.com>
 <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110171119580.3240@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:38:03AM +0200, Thomas Gleixner wrote:

> Unfortunately this is a full speed rolling trainwreck already. The
> whole app space is made to encourage shitty applications. Android is
> designed exactly in that way and it seems that all other desktop folks
> have fully adopted that adsurdity.
> 
> Back when NOHZ was merged in the kernel, powertop made people fix crap
> left and right in not time. Why should we add something which actively
> fosters crappy applications today?

They're orthogonal. Sometimes you want timer-driven behaviour (how else 
are you going to draw animations?) and that's obviously going to 
generate wakeups. This is for the idle case, where the user is no longer 
sitting in front of the machine but you don't want to trigger a full 
system suspend. We either need every application that ever uses 
timer-driven behaviour to support setting its own timer slack on some 
sort of external policy decision, or we need a way to let the kernel 
force them to.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
