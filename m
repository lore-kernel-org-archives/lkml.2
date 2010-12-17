Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0LQPyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:54:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44616 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0LQPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nDGaTDVmmEqiiwrfsIrZKySUrmxUJA2Uv01pqAXKT+ZcB1XQEIL2HUBVj4uXItfABG
         Thbppn3RWbv3qUDflfdoqSFKOAGBGvVxZ+cCGAozSWued+iZjd9L86ddUlm81tBX1+Ai
         AjFyc5jIEsWtY5gXBGHD+c3EStd/mY5a52/7k=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292596369.2266.286.camel@twins>
	<AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
	<1292599007.2266.290.camel@twins>
	<alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
Date: Fri, 17 Dec 2010 16:54:04 +0100
Message-ID: <AANLkTim3gwwnJmWTbAVRo50JTgHENriJdEPk+v68W8ns@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Thomas Gleixner <tglx@linutronix.de>:
> Also if you want to have your deadline scheduler aware of cpu
> frequency changes, then simply limit the total bandwith based on the
> lowest possible frequency and it works always. This whole dynamic
> bandwith expansion is more an academic exercise than a practical
> necessity.

This would severely limit the bandwidth available to deadline tasks. Which
then also reduces the use cases that could benefit from using sched deadline.
Also it would imply a over-reservation of the system, e.g. if you need 10%
BW of the total system and the lowest speed is at 20%, you basically need to
set a BW of 50%, to always be guaranteed that you get your 10% when cpufreq
clocks down. If you use cpufreq and want to use sched deadline this has
strong practical implications and is definitely not academic only.
