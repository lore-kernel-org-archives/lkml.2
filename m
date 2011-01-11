Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1AKIbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:31:00 -0500
Received: from shutemov.name ([188.40.19.243]:52016 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1AKIaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:30:55 -0500
Date: Tue, 11 Jan 2011 10:30:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, johnstul@us.ibm.com, williams@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/tsc] x86: Improve TSC calibration using a delayed
 workqueue
Message-ID: <20110111083054.GB22867@shutemov.name>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
 <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
 <20110111081352.GA22867@shutemov.name>
 <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 09:26:48AM +0100, Thomas Gleixner wrote:
> On Tue, 11 Jan 2011, Kirill A. Shutemov wrote:
> 
> > On Sun, Dec 05, 2010 at 11:18:53AM +0000, tip-bot for John Stultz wrote:
> > > Commit-ID:  08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > > Gitweb:     http://git.kernel.org/tip/08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > > Author:     John Stultz <johnstul@us.ibm.com>
> > > AuthorDate: Tue, 27 Jul 2010 17:00:00 -0700
> > > Committer:  John Stultz <john.stultz@linaro.org>
> > > CommitDate: Thu, 2 Dec 2010 16:48:37 -0800
> > > 
> > > x86: Improve TSC calibration using a delayed workqueue
> > 
> > This commit breaks booting the kernel in qemu with enabled KVM on my machine.
> > .config attached.
> > 
> > [    0.424013] divide error: 0000 [#1] 
> 
> Got fixed by a8760ec (x86: Check tsc available/disabled in the delayed
> init function)

No, it didn't. :(

I am able to reproduce it on current Linus' tree (v2.6.37-4700-g8adbf8d).

-- 
 Kirill A. Shutemov
