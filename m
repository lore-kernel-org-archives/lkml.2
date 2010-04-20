Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0DTJVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:21:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:39534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab0DTJVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:21:42 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Tue, 20 Apr 2010 11:24:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: =?utf-8?q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org> <4BCC147B.10708@tremplin-utc.net> <20100419064325.49cb3108@infradead.org>
In-Reply-To: <20100419064325.49cb3108@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004201124.00326.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010 15:43:25 Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 10:29:47 +0200
> Éric Piel <eric.piel@tremplin-utc.net> wrote:
> > > 
> > > The problem and fix are both verified with the "perf timechar" tool.
> > Hi,
> > I don't doubt that keeping the cpu full frequency during IO can
> > improve some specific workloads, however in your log message you
> > don't explain how much we are loosing.
> 
> first of all, it's so bad that people will just turn the whole power
> management off... at which point fixing the really bad bug is actually
> quite a win
Not sure you fix a bug, I expect this was done on purpose.
The ondemand governor disadvantages processes with alternating short CPU
load peaks and idle sequences.
IO bound processes typically show up with such a behavior.

But I follow Eric and agree that if it costs that much, changing
above sounds sane.
Still, I could imagine some people might want to not raise freq on IO bound
process activity, therefore this should get another ondemand param, similar
to ignore_nice_load.

    Thomas
