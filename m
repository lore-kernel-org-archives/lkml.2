Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1FNQDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:03:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1FNQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:03:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Tue, 14 Jun 2011 18:03:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106141549.29315.arnd@arndb.de> <op.vw2jmhir3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vw2jmhir3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141803.00876.arnd@arndb.de>
X-Provags-ID: V02:K0:DoXejs+Xs1l8544LKmLCA5ZKlcprlmwA4/1368dgzUP
 UnNbg49pKFUpZDaF+KkT13O1c/0d99fgLfddgsTE7+2S3iZlDG
 08gGLFSoPG0K7VZOXVSlGPCuTXD3LCgX/3tD0tNxf+8z8n6MUR
 Okfa3q16NJ3aIz5kQA+7iAPdq9m7p5H9jpeHha8zQqw9IOOXWM
 Qx4Sl/zjASWOZP3lPQ4Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011, Michal Nazarewicz wrote:
> On Tue, 14 Jun 2011 15:49:29 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> > Please explain the exact requirements that lead you to defining multiple
> > contexts.
> 
> Some devices may have access only to some banks of memory.  Some devices
> may use different banks of memory for different purposes.

For all I know, that is something that is only true for a few very special
Samsung devices, and is completely unrelated of the need for contiguous
allocations, so this approach becomes pointless as soon as the next
generation of that chip grows an IOMMU, where we don't handle the special
bank attributes. Also, the way I understood the situation for the Samsung
SoC during the Budapest discussion, it's only a performance hack, not a
functional requirement, unless you count '1080p playback' as a functional
requirement.

Supporting contiguous allocation is a very useful goal and many people want
this, but supporting a crazy one-off hardware design with lots of generic
infrastructure is going a bit too far. If you can't be more specific than
'some devices may need this', I would suggest going forward without having
multiple regions:

* Remove the registration of specific addresses from the initial patch
  set (but keep the patch).
* Add a heuristic plus command-line override to automatically come up
  with a reasonable location+size for *one* CMA area in the system.
* Ship the patch to add support for multiple CMA areas with the BSP
  for the boards that need it (if any).
* Wait for someone on a non-Samsung SoC to run into the same problem,
  then have /them/ get the final patch in.

Even if you think you can convince enough people that having support
for distinct predefined regions is a good idea, I would recommend
splitting that out of the initial merge so we can have that discussion
separately from the other issues.

	Arnd
