Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0HZRfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:35:05 -0400
Received: from n10.bullet.mail.ac4.yahoo.com ([76.13.13.238]:26696 "HELO
	n10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752526Ab0HZRfB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:35:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 379441.69451.bm@omp204.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kY916DCPSA1HehpxneS+N8bIxzz8By/UKnwaYwuM98w8Bb1CpAFmTVo3XScjbZSxc6XnqHFS4zlacd+6Fu64e9aHa1B7n7fye+5/FDJcUPLzv27DVEEOUdkBm0MuAY4x4dmFpfGyw9i5kKd3rc8URMX33B28Ldl4a6rqlYZb59M=;
Message-ID: <216397.86259.qm@web180306.mail.gq1.yahoo.com>
X-YMail-OSG: OySU9hMVM1mRK0fNEYHjDKcxmh0jF3TdvDewFLKHv1sc.KO
 LCm0O2RXAP2CPofUqe3D4Gj3tFWReG4JAN0AYOvBM4GomaYHq2bgtQYop4uL
 tgeE06Wp.OoBoxFjLClpWG2h7x7xMocv8AhaZo2OEulVQZWOv699jl2maC4S
 xhKi6Y2y7TDmk6PVNT0GcLy1NLaHqgnoTIWqHlwQY9Xy4wfBg2Qa5NNuzNe1
 s_I_hpFMvcmWe8wedNNcbaex7pSHIAsd2ezFs.RlhWTVWMzoriYrFx1V9cPk
 1loJR8V3ARZss1JLZhFBLnIE4KPbnOhi.f6oOl4Qc2H0VHSdFE52EsoC2BKV
 TPORmctsDS.Wq7SM-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 26 Aug 2010 10:34:58 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped controllers
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100826174822.75094415@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 8/26/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Just rename it to match the IP block used.
> 
> There are zillions of IP blocks that have that interface,

If there are "zillions" that suggests the HW
engineers have version/naming issues just like
certain software engineers.  Only goes to show
how close Verilog and VHDL are to software! :)


> how exactly do
> you propose to rename it.

My suggestion was to use the name provided/used
by the hardware engineers.  (E.g. whatever the
Verilog or VHDL equivalent of a module name is.)

So -- NO RENAME -- except for the driver.

If I understand you correctly, those engineers
are not reusing a named module; they are at best
just copying/pasting some Verilog/VHDL and adding
ASIC/SoC/.../FPGA-specific hacks.  (Which calls into
question just how much assurance there can be that
one driver will work reliably for all instances...


> > That removes all confusion.  Engineers will
> >  be able to know more easily whether this
> > driver is even relevant to them.
> 
> Not unless its got a name about 1000 characters long
> listing all the
> devices it might drive - and changes name weekly.

Someone should have a few words with those hardware
engineers about module naming and consistency, so
software doesn't need to work around such issues.

Such problems have been solved for decades, and
there's no reason to create confusion higher up
the system stack.  (or force workarounds.)


> > An example might be "amba-9999 (a made-up
> > number, likely not matching a GPIO controller).

Note that such names are already used in Linux
with IP blocks from AMBA; Designware blocks, as
I noted, aren't dissimilar (dw_foo.c in at least
a few cases).

> What's wrong with a sensible generic name like
> gpio-mmio-table ?


That's a much better name.  I'ts got technical
content, even!  (vs "simple" being "marketing",
including easy confusion with other entities).

All I'll say is that it might
 be *too* generic a name.  I know I can come up
with current examples of GPIO done via MMIO
(tables) that this driver won't fit at all.
That can probably be worked around via docs and
conventions.

There'd need to be good docs on what this
gpio-mmio-table interface expects.  Some of that
belongs in Kconfig, not much; mostly I'd think
it belongs in driver header comments, but also
some in the patch comment itself.  I hear you
strongly implying that there's no generic hardware
doc to reference.  (As theree would be if this
block came from the AMBA or DesignWare families.)




