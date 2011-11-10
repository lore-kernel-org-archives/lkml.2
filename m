Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab1KJL42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1KJL40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:56:26 -0500
Date: Thu, 10 Nov 2011 13:56:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111110115603.GV3225@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
 <20111108124906.GO3225@redhat.com>
 <1320758811.11519.1.camel@twins>
 <20111108135432.GP3225@redhat.com>
 <1320761547.11519.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320761547.11519.3.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 03:12:27PM +0100, Peter Zijlstra wrote:
> > I do not want to introduce
> > incidental regressions. For instance the patch below will introduce
> > regression on my Nehalem cpu. It reports value 0x44 in cpuid10.ebx which
> > means that unhalted_reference_cycles is not available (bit set means
> > event is not available), but event still works! Actually it is listed as
> > supported by the cpu in Table A-4 SDM 3B. Go figure. 
> 
> We'd better figure out why your machine says that. It could be we need
> another quirk for the nehalem machines, it could be your BIOS is smoking
> crack and there's nothing we can do about it.
> 
Looks like on nehalem 013c event does not count unhalted reference
cycles like spec says it should, but instead increments with 133MHZ
frequency. So disabling it should be the right thing to do.

--
			Gleb.
