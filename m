Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0GJQZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 12:25:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0GJQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 12:25:50 -0400
Date: Sat, 10 Jul 2010 09:29:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] pm: Add runtime PM statistics to sysfs
Message-ID: <20100710092942.1fa1d80c@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.1007091106070.1582-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1007091056510.1582-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1007091106070.1582-100000@iolanthe.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 11:11:06 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> This is because update_pm_runtime_accounting() doesn't take into 
> account the existence of the RPM_RESUMING and RPM_SUSPENDING states;
> it treats them all the same as RPM_ACTIVE.

this is by design fwiw; I'm considering the time spent going in and out
of suspend as "active", it's a little on the conservative side, but the
underlying assumption is that you're still burning power until you're
really suspended. Better to be conservative and not count it as really
suspended....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
