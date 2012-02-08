Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2BHJgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:36:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55858 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2BHJgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:36:47 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: "Christoph Lameter" <cl@linux.com>, "Chris Metcalf" <cmetcalf@tilera.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        "Avi Kivity" <avi@redhat.com>,
        "Kosaki Motohiro" <kosaki.motohiro@gmail.com>,
        "Milton Miller" <miltonm@bga.com>
Subject: Re: [PATCH v8 0/8] Reduce cross CPU IPI interference
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
Date: Wed, 08 Feb 2012 10:36:42 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9cszgo23l0zgt@mpn-glaptop>
In-Reply-To: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Feb 2012 14:33:20 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> This patch set, inspired by discussions with Peter Zijlstra and Frederic
> Weisbecker when testing the nohz task patch set, is a first stab at trying
> to explore doing this by locating the places where such global IPI calls
> are being made and turning the global IPI into an IPI for a specific group
> of CPUs.  The purpose of the patch set is to get feedback if this is the
> right way to go for dealing with this issue and indeed, if the issue is
> even worth dealing with at all. Based on the feedback from this patch set
> I plan to offer further patches that address similar issue in other code
> paths.
>
> The patch creates an on_each_cpu_mask and on_each_cpu_cond infrastructure
> API (the former derived from existing arch specific versions in Tile and
> Arm) and uses them to turn several global IPI invocation to per CPU
> group invocations.

> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Christoph Lameter <cl@linux.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: linux-mm@kvack.org
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Matt Mackall <mpm@selenic.com>
> CC: Sasha Levin <levinsasha928@gmail.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> CC: Avi Kivity <avi@redhat.com>
> CC: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

for patches form 1 to 4 and 7.  The other two (5 and 6) look good but
I don't know enough about slub and fs to feel confident acking.

> CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
> CC: Milton Miller <miltonm@bga.com>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
