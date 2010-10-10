Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab0JJUUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:20:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JJUUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:20:37 -0400
Date: Sun, 10 Oct 2010 22:20:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101010202031.GD21681@basil.fritz.box>
References: <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <20101010170151.GD28828@agk-dp.fab.redhat.com>
 <20101010174454.GA21681@basil.fritz.box>
 <20101010181736.GE28828@agk-dp.fab.redhat.com>
 <20101010185100.GB21681@basil.fritz.box>
 <20101010190734.GH28828@agk-dp.fab.redhat.com>
 <20101010191640.GC21681@basil.fritz.box>
 <4CB21492.8050101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB21492.8050101@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But previously, there were threads per device, so if one IO thread blocks,
> others stacked mappings can continue
> Now I see possibility for deadlock there because we have one io thread now
> (assuming that 1 CPU situation Alasdair mentioned).

That path calls the crypto worker thread, not the IO worker thread?
crypto worker should be fine here, only IO worker would be a problem
I think because crypto doesn't really block on nested IO.

-Andi

