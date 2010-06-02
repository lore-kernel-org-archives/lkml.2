Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0FBGOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:14:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48630 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab0FBGOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:14:46 -0400
Date: Wed, 2 Jun 2010 08:14:32 +0200
From: Florian Mickler <florian@mickler.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, 640e9920@gmail.com,
       markgross@thegnar.org, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pm_qos: remove unnecessary list-traversal
Message-ID: <20100602081432.7a5e5f5d@schatten.dmk.lab>
In-Reply-To: <alpine.LFD.2.00.1006011240360.2933@localhost.localdomain>
References: <1275382014-10178-1-git-send-email-florian@mickler.org>
	<1275382331-15180-1-git-send-email-florian@mickler.org>
	<alpine.LFD.2.00.1006011240360.2933@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 12:43:21 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 1 Jun 2010, florian@mickler.org wrote:
> 
> > The new extreme value is only depending on the old extreme value and
> > the changed value.
> 
> And how does that update to the next applicable constraint when the
> current constraint is removed ? Your patch is creating a one way
> decision.

keeping the list sorted or using an rbtree is the answer then. 

if O(1) behaviour is needed maybe another constraint type could be
implemented. Maybe using a bool or even a bitmap (to allow for 32
constraint-values). 
Is another constraint-type worthwile? 

>  
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > ---
> > This version actually compiles...  :)
> 
> That does not make it work.
> 
>      tglx

indeed.

Cheers,
Flo
