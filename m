Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1J0AHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:07:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:38140 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab1J0AHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:07:03 -0400
Date: Thu, 27 Oct 2011 09:01:53 +0900
To: ebiederm@xmission.com
Cc: konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 swiotlb: Verify we can perform the remapping
 requested.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <m1ty6yig24.fsf@fess.ebiederm.org>
References: <m1lisj48q1.fsf@fess.ebiederm.org>
	<20111021004031.GB13687@phenom.dumpdata.com>
	<m1ty6yig24.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20111027090019T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 27 Oct 2011 09:01:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 08:07:31 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> 
> > On Mon, Oct 17, 2011 at 02:19:18PM -0700, Eric W. Biederman wrote:
> >> 
> >> Recently I had a driver try with a peculiar 2G dma memory limit.
> >> It failed in weird and strange ways because my bounce buffers were
> >> being allocated above 2G where the driver could not reach, and
> >> no error was reported when the mappings were setup.
> >
> > OK, so the overflow buffer was used instead.. which presumarily
> > also was allocated above the 2G? That seems to point that
> > alloc_bootmem_low_pages is not doing its job?
> 
> I just looked alloc_bootmem_low_pages allocates memory below
> ARCH_ADDRESS_LIMIT which for everything except s390 is 4G.
> 
> I know I was mostly using the amd gart driver.  So I may be mistaken
> that the swiotlb driver had the same issue.  However my only solution
> at the time was to boot with mem=2G.  So I believe the swiotlb did
> have this issue.
> 
> Mostly the patch was.  Hmm.  That looks stupid not wiring up the
> swiotlb address space limit check when someone has already written it.

http://www.gossamer-threads.com/lists/linux/kernel/1333685?do=post_view_threaded#1333685

swiotlb isn't designed to handle hardware having odd dma mask (e.g. 2G
or something). Such device needs the own bouncing mechanism.
