Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0JTRct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab0JTRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:32:48 -0400
Date: Wed, 20 Oct 2010 18:32:31 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Message-ID: <20101020173231.GP3935@agk-dp.fab.redhat.com>
Mail-Followup-To: Milan Broz <mbroz@redhat.com>,
	Andi Kleen <ak@linux.intel.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com> <4CB20C72.3030504@redhat.com> <4CB7595C.4000801@redhat.com> <4CBEFABC.3030400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBEFABC.3030400@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:20:44PM +0200, Milan Broz wrote:
> this patch introduces apparent regressions in async crypto mode.
 
OK, thanks for performing those tests.

This patch is stalled until these problems are understood properly and
solutions are proposed.  I was prepared to overlook the regression in
stacked 'async' provided there was an inline FIXME explaining clearly
how to fix it in future should we need to, but I can't support a patch that
apparently breaks stacked sync encryption.

One solution might be to make the proposed changes only for non-stacked
configurations and leave stacks to work as they do today - either
detecting that automatically or having userspace supply a target
parameter to say whether or not to turn it on.  (For that, would need
tests to show a stack of many layers where only one is a crypt target
continues to work after the change.)

Alasdair

