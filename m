Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2FDT5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:57:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:42949 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2FDT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:57:07 -0400
Date: Mon, 4 Jun 2012 21:57:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Chen Gong <gong.chen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "bp@amd64.org" <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [patch 1/2] x86: mce Cleanup timer mess
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F7E3F@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1206042155260.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.391516712@linutronix.de> <4FCC1BE4.3070404@linux.intel.com> <3908561D78D1C84285E8C5FCA982C28F192F7E3F@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Luck, Tony wrote:

> > Here Thomas changed original mode from "*n = max(*n/2, HZ/100);"
> > to "iv = max(iv, (unsigned long) HZ/100);", which means *iv* will not
> > be decremented but only incremented in _else_ branch. If so, eventually
> > the *iv will be equal to *check_interval*. I don't think it makes sense.
> 
> It looks like Thomas just forgot the "/ 2" there while cleaning up.
> I didn't see it either, nor did Boris when he acked it. Thank goodness
> for your extra eyes looking at this.

Uurgh. Chen, thanks for spotting it!
