Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0FXLfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:35:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0FXLe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:34:59 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624112340.GA13502@elte.hu>
References: <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
	 <1277363993.1875.847.camel@laptop>
	 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
	 <1277364727.1875.857.camel@laptop> <20100624102725.GA578@basil.fritz.box>
	 <1277375409.1875.943.camel@laptop> <20100624105254.GB578@basil.fritz.box>
	 <1277377121.1875.948.camel@laptop> <20100624110830.GC578@basil.fritz.box>
	 <1277377852.1875.950.camel@laptop>  <20100624112340.GA13502@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 13:34:54 +0200
Message-ID: <1277379294.1875.959.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:23 +0200, Ingo Molnar wrote:

> What might make sense is to offer two types of callbacks: one that is 
> immediate whenever an event triggers - and another that is sleepable and is 
> executed from process context.

Trouble is waking that thread, you cannot wake tasks from NMI context,
so whatever you do, you'll end up with a trampoline.

You could of course offer that trampoline nicely packaged, but I'm not
sure that's really worth the effort.
