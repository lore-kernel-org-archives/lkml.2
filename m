Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2JCKWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:22:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60009 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2JCKWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:22:17 -0400
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rick Jones <rick.jones2@hp.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20121003094732.GQ29125@suse.de>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de> <506B6F59.8060800@hp.com>
	 <20121003094732.GQ29125@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Oct 2012 12:22:11 +0200
Message-ID: <1349259731.12401.1842.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 10:47 +0100, Mel Gorman wrote:
> On Tue, Oct 02, 2012 at 03:48:57PM -0700, Rick Jones wrote:

> > PS - I trust it is the receive-side throughput being reported/used
> > with UDP_STREAM :)
> 
> Good question. Now that I examine the scripts, it is in fact the sending
> side that is being reported which is flawed. Granted I'm not expecting any
> UDP loss on loopback and looking through a range of results, the
> difference is marginal. It's still wrong to report just the sending side
> for UDP_STREAM and I'll correct the scripts for it in the future.

You can have drops even on loopback if the receiver doesnt drain its
socket receive queue fast enough.



