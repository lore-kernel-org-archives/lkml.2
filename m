Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2AIR5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:57:52 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:24574 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2AIR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:57:51 -0500
Message-ID: <4F0B2A9D.5020208@tilera.com>
Date: Mon, 9 Jan 2012 12:57:49 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH v6 0/8] Reduce cross CPU IPI interference
References: <y> <1326040026-7285-1-git-send-email-gilad@benyossef.com>
In-Reply-To: <1326040026-7285-1-git-send-email-gilad@benyossef.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2012 11:26 AM, Gilad Ben-Yossef wrote:
> We have lots of infrastructure in place to partition a multi-core systems
> such that we have a group of CPUs that are dedicated to specific task:
> cgroups, scheduler and interrupt affinity and cpuisol boot parameter.
> Still, kernel code will some time interrupt all CPUs in the system via IPIs
> for various needs. These IPIs are useful and cannot be avoided altogether,
> but in certain cases it is possible to interrupt only specific CPUs that
> have useful work to do and not the entire system.
>
> This patch set, inspired by discussions with Peter Zijlstra and Frederic
> Weisbecker when testing the nohz task patch set, is a first stab at trying
> to explore doing this by locating the places where such global IPI calls
> are being made and turning a global IPI into an IPI for a specific group
> of CPUs.  The purpose of the patch set is to get feedback if this is the
> right way to go for dealing with this issue and indeed, if the issue is
> even worth dealing with at all. Based on the feedback from this patch set
> I plan to offer further patches that address similar issue in other code
> paths.
>
> The patch creates an on_each_cpu_mask and on_each_cpu_conf infrastructure 
> API (the former derived from existing arch specific versions in Tile and 
> Arm) and and uses them to turn several global IPI invocation to per CPU 
> group invocations.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

(To be fair, mostly this acks the proposed infrastructure, and moving the
functions out of the tile architecture and into the generic code; I not
expert enough at slub or the invalidate_bh_lrus path to ack those changes,
other than to say I like how they look.)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

