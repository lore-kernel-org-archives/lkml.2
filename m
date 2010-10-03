Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0JCMEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:04:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:33866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0JCMEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:04:48 -0400
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35,
 2.6.35.1 and later
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: tmhikaru@gmail.com, linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101003121209.586f7b6b@schatten.dmk.lab>
References: <20101001035321.GA2360@roll> <20101001094814.GA5029@roll>
	 <20101003030254.GA4901@roll> <1286095268.2144.119.camel@laptop>
	 <20101003121209.586f7b6b@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 03 Oct 2010 14:04:38 +0200
Message-ID: <1286107478.2144.177.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 12:12 +0200, Florian Mickler wrote:
> On Sun, 03 Oct 2010 10:41:08 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2010-10-02 at 23:02 -0400, tmhikaru@gmail.com wrote:
> > >  The load average statistic is indeed broken somehow, and I
> > > did bisect it down to where the problem began, however there seems to be no
> > > performance problem related to it I can find. 
> > 
> > Chase, anything you can see broken with this stuff?
> 
> Peter, do you think it would be worthwile to test a kernel with the
> low load-averages in NOHZ=disable mode? The bisected commit claims to
> fix a NOHZ issue with the load average. So if the new figures are the
> correct ones, they should be somehow similar to the figures before
> with NOHZ? Or am I on the wrong track here?

No, that makes sense, but there is of course the distinct possibility
that the patch wrecked the !nohz path as well. So ideally you'd have to
compare NOHZ=n with this patch reverted and NOHZ=y with this patch in
place.


