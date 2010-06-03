Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0FCNoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:44:34 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:26983 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751766Ab0FCNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:44:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 938332.54916.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=4AdjxNBlApOxK3w/Xw4aguA7n1FSNcyPZfCKqZeMzfuey4Vt3w2LQ8JhIsJWppe9qPdLu+9fbSksr/MJ825KmGzsiBbJGaFHd7sETgCNa88UZUudIEnLrCpP3K9qZSQSvKJQ7pJz64HlvqosqnshvCnJ0dH/NP6nAWy3Hu+/P3E=;
Message-ID: <806772.17066.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: igoI8.0VM1neTPPFm6KhPeSEkXNikrF8KJZwqWb1b8W7Yyf
 xBOdUEPIcMOPZEd5qHF2AYDU9p5SLvaf9lJpsjZHfYhRUPao7nFd6u.M7YbR
 Nl83hm4JzgT5OMQMm4AeXJ23wIpnfV8T2mMAcphE6t.IZGDOdv.Mx4NAetHt
 qRLltspYaR7JUGYgUxeCJfCwcqqPzdrbxbSk5.OcjZuFNpkdVmoUCotDalqj
 iwQ7RCoZFyR_JGp56GoHWK8zkAssOdCxxYcnPHZu8EAKSJAhRXdQXk84AiEl
 gb4y0zDEiKdytGUA5tKo-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 3 Jun 2010 06:44:31 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
To: Thomas Gleixner <tglx@linutronix.de>,
       Florian Mickler <florian@mickler.org>
Cc: Neil Brown <neilb@suse.de>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Alan@smtp1.linux-foundation.org,
       Peter Zijlstra <peterz@infradead.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100601073548.5ed65352@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > If "suspend" is the thing we are used to via
> /sys/power/state then the
> > > race will persist forever except for the suspend blocker workaround,

True, because device wakeups are enabled
by device.driver.suspend() methods, which are
invoked towards the end of the activities
triggered by writing /sys/power/state.

Now, there can be platforms (mostly embedded)
where the drivers adopt a policy that not only
do they keep their devices in as low a power
state as practical at all times, but they also
keep the hardware wakeup mechanisms enabled (they
may be needed to kick the hardware out of those
low power states) ...  That is, suspend() might be
superfluous (a NOP) in those platforms' drivers.

Such platforms might also be (non-ACPI) ones
where idle C-states and S3/STR have the same
power consumption ... but that would be a
platform-specific issue, not a generic thing
which all Linux implementations could rely on.

- Dave


