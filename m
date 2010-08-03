Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0HCJqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:46:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0HCJq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:46:29 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
        Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir>
	 <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 11:46:15 +0200
Message-ID: <1280828775.1923.447.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
> If you want to do G-EDF with limited and different budgets on each CPU
> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
> restricted-supply scheduling, which is significantly more complicated
> to analyze (see [1,2]).

Would making the thing homogenious by assuming the worst for all cpus
make the analysis easier? That is, in the above example, only allow the
G-EDF scheduler to run for 100 out of 1000 ms on both cpus.


