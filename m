Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0LQPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:06:18 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:63259 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0LQPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rHHZnT/qZaj3f+2Ze0WiOWLSs3+G47MuyvYaZopYdR9Bqp8xnbYe1zfckuToAJgc09
         N+THSn9tscLP5wMn6BdiLBKPCNazK+yWe6ly65jCp9uVapzbvg01BFOUwuisKUE0/mx+
         l+/Rbk9S8x1lFrKlRtAAzHgvAZoYe6PYGaNE4=
MIME-Version: 1.0
In-Reply-To: <1292596369.2266.286.camel@twins>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292596369.2266.286.camel@twins>
Date: Fri, 17 Dec 2010 16:06:16 +0100
Message-ID: <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Peter Zijlstra <peterz@infradead.org>:
> This is all assuming lowering the frequency is sensible to begin with in
> the first place... but that's all part of the CPUfreq governor, it needs
> to find a way to lower energy usage while conforming to the system
> constraints.

Yes, I and you have already suggested the safe way to not lower it below
the total dl bandwidth. But for softer use cases it might be possible to
e.g. exclude threads with longer periods than cpufreq change periods in the
minimum frequency.
