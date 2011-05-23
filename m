Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1EWHsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:48:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1EWHsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:48:30 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <BANLkTimZhpfgKoEki16r5zabNCrvK-GsUw@mail.gmail.com>
References: <20110520143716.GA5381@quad> <1305903917.2466.7237.camel@twins>
	 <BANLkTimZhpfgKoEki16r5zabNCrvK-GsUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 09:47:58 +0200
Message-ID: <1306136878.18455.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 18:45 +0200, Stephane Eranian wrote:
> On Fri, May 20, 2011 at 5:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-05-20 at 16:37 +0200, Stephane Eranian wrote:
> >> The is_fake field is necessary to avoid a lockdep issue having
> >> to do with interrupt masking and era->lock.
> >
> > Why not simply disable IRQs in both validate_* functions?
> >
> Could do that too if you think that's cleaner.

Its saner than making that code path conditional, but an alternative
solution is to give the fake thing a different lock class.
