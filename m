Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0DSNls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:41:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:36686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0DSNlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:41:46 -0400
Date: Mon, 19 Apr 2010 06:43:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100419064325.49cb3108@infradead.org>
In-Reply-To: <4BCC147B.10708@tremplin-utc.net>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<4BCC147B.10708@tremplin-utc.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 10:29:47 +0200
Éric Piel <eric.piel@tremplin-utc.net> wrote:
> > 
> > The problem and fix are both verified with the "perf timechar" tool.
> Hi,
> I don't doubt that keeping the cpu full frequency during IO can
> improve some specific workloads, however in your log message you
> don't explain how much we are loosing.

first of all, it's so bad that people will just turn the whole power
management off... at which point fixing the really bad bug is actually
quite a win 

> 
> How much more energy is consumed when doing a "updatedb" or "find /" ?

on the machines I used this on (Core i7's) it's actually hardly
measurable. All CPUs I have access to turn the voltage entirely off
during idle, so while the frequency is higher, if you're mostly IO
bound, it's only for very short durations... while still being mostly
"off".

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
