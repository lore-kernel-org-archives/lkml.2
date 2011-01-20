Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1ATR1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:27:18 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:46783 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ATR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:27:16 -0500
Date: Thu, 20 Jan 2011 11:27:30 -0600
From: William Pitcock <nenolod@dereferenced.org>
To: Malcolm Scott <lkml@malc.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS deadlock in 2.6.37
Message-ID: <20110120112730.393f6ff0@petrie>
In-Reply-To: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
References: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 20 Jan 2011 17:08:45 +0000 (GMT)
Malcolm Scott <lkml@malc.org.uk> wrote:

> Hi all,
> 
> I've had the following deadlock happen twice on a 2.6.37 system with
> several XFS filesystems (including root) and no swap (may be
> relevant, considering that kswapd is one task involved here).  Some
> minor filesystem corruption resulted (but maybe only because the root
> fs couldn't be synced/umounted).
> 

kswapd also handles swapping pages in and out of the filesystem cache
as part of the VM subsystem.  I have a hunch that if you do a bisect
of commits relating to the VM subsystem, you will find the commit that
is causing this.

Also, are you building with BKL enabled or disabled?

William
