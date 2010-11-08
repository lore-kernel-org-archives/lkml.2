Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0KHSMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:12:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:34003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0KHSMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:12:32 -0500
Subject: Re: [PATCH 3/3] futex: add futex_q static initializer
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>, mingo@elte.hu,
        eric.dumazet@gmail.com, jkacur@redhat.com,
        Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1011081724460.2900@localhost6.localdomain6>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
	 <1288216466-14309-4-git-send-email-dvhart@linux.intel.com>
	 <alpine.LFD.2.00.1011081724460.2900@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Nov 2010 19:12:31 +0100
Message-ID: <1289239951.2191.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 17:42 +0100, Thomas Gleixner wrote:
> > +#define FUTEX_Q_INIT \
> > +     { /* list gets initialized in queue_me()*/ \
> > +       .task = NULL, NULL, FUTEX_KEY_INIT \
> > +     , NULL, NULL, NULL, FUTEX_BITSET_MATCH_ANY }
> > +
> 
> That should be a static readonly variable with a proper C99
> initializer. 

Well, it doesn't need to actually be an existing variable, but yeah it
should definately use C99 initializers.
