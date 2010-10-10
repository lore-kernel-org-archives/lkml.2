Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0JJTQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:16:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0JJTQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:16:42 -0400
Date: Sun, 10 Oct 2010 21:16:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010191640.GC21681@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <20101010170151.GD28828@agk-dp.fab.redhat.com>
 <20101010174454.GA21681@basil.fritz.box>
 <20101010181736.GE28828@agk-dp.fab.redhat.com>
 <20101010185100.GB21681@basil.fritz.box>
 <20101010190734.GH28828@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010190734.GH28828@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not if in_interrupt is set though?
> +       if (per_cpu(io_wq_cpu, cpu) == current && !in_interrupt()) {
> 
> What I am missing here?

The interrupt doesn't block on the task.

Actually most likely that check isn't needed anyways because
that should not happen, was just pure paranoia from my side.

> 
> (And assume there is only 1 CPU too for worst case behaviour, presumably.)

One per process, previously it was always one per CPU.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
