Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0FHNqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:46:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0FHNqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:46:34 -0400
Subject: Re: [PROPOSAL - FIRST POST] NMI & register clash handling
 infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Oza Oza <ozaoza1982@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <825203.31628.qm@web95605.mail.in.yahoo.com>
References: <825203.31628.qm@web95605.mail.in.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Jun 2010 15:46:32 +0200
Message-ID: <1276004792.2987.225.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 14:34 +0530, Oza Oza wrote:


> My proposal/idea/thinking is; 
> have a kernel module which accepts NMI registration from any kernel component, and providing support to the the any kernel service which basically need to service NMI.
> It may not only supports this, but also can provide central infrastructure which has capabilities such as granting MSR (model specific register) access to the the modules, which may avoid potential clash of MSRs (e.g. two modules are trying to configure same MSR), control NMI registration-unregisteration events etc..

We have such a thing, look at register_die_notifier() users, you want to
register for the DIE_NMI notifier.

In fact, if you'd have read the oprofile code, you'd have encountered
these.
