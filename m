Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2LKJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:21:34 -0500
Received: from gate.in-addr.de ([212.8.193.158]:60339 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751421Ab2LKJVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:21:32 -0500
X-Greylist: delayed 1395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 04:21:32 EST
Date: Tue, 11 Dec 2012 09:56:45 +0100
From: Lars Marowsky-Bree <lmb@suse.de>
To: device-mapper development <dm-devel@redhat.com>
Cc: gzhao@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] add resync speed control for dm-raid1
Message-ID: <20121211085645.GH32224@suse.de>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <20121210132123.5a4ab015@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121210132123.5a4ab015@notabene.brown>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-10T13:21:23, NeilBrown <neilb@suse.de> wrote:

> The problem with this approach is that it slows down resync even when there
> is no other IO happening.
> If that is deemed to be acceptable, then the patch set seems fine, though I
> would probably make the default a lot higher so as not to change current
> default behaviour for anyone.

I agree to the latter part.

The difficulty is that our primary use case here is preventing IO
starvation while cluster raid is resyncing; and we don't know the IO
load on other nodes, or what other LVs might inflict on the same backend
store / PV. Hence, a static limit probably is the easiest way to
start.

I agree that a more dynamic approach would be desirable, but that
appears to be very complex to get right.


Thanks,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 21284 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

