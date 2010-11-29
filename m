Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0K2Lie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:38:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54130 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0K2Lid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:38:33 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <20101128114027.GA2745@brouette>
References: <1288101958.15336.284.camel@twins>
	 <1288381343.1988.12.camel@laptop>
	 <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	 <1290888920.32004.1.camel@laptop>  <20101128114027.GA2745@brouette>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:38:46 +0100
Message-ID: <1291030726.32004.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 12:40 +0100, Damien Wyart wrote:
> Hi,
> 
> * Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> > How does this work for you? Its hideous but lets start simple.
> > [...]
> 
> Doesn't give wrong numbers like initial bug and tentative patches, but
> feels a bit too slow when numbers go up and down. Correct values are
> reached when waiting long enough, but it feels slow.
> 
> As I've tested many combinations, maybe this is an impression because
> I do not remember about "normal" delays for the load to rise and fall,
> but this still feels slow.

You can test this by either booting with nohz=off, or builting with
CONFIG_NO_HZ=n and then comparing the result, something like

make O=defconfig clean; while sleep 10; do uptime >> load.log; done &
make -j32 O=defconfig; kill %1

And comparing the curves between the NO_HZ and !NO_HZ kernels.

I'll try and make the patch less hideous ;-)
