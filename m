Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab1D2Plb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:41:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1D2Pla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:41:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Fri, 29 Apr 2011 17:41:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <201104271243.16868.arnd@arndb.de> <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291741.18190.arnd@arndb.de>
X-Provags-ID: V02:K0:GSNWqtqTdqgaEc6Myu4Q4PjhNxytezCbrS1BP83mtUG
 a94Ie9CfOtMIsX/UG3cHg/uE901kJm++2qmXzW817GUTpENb3D
 XsQcbpqQIAfEdYuGAS8D444D2u2q/PqqkDGjk+Gg8/V7Kp2lV4
 SjvobbX33gp9uzaxnk/jqW1rvlTbCU1WLwvVFaiyI7DVbUS5+3
 1NhMkKEoHxdu6NsTC/FhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Catalin Marinas wrote:
> > >
> > > It's not broken since we moved to using Normal non-cacheable memory
> > > for the coherent DMA buffers (as long as you flush the cacheable alias
> > > before using the buffer, as we already do). The ARM ARM currently says
> > > unpredictable for such situations but this is being clarified in
> > > future updates and the Normal non-cacheable vs cacheable aliases can
> > > be used (given correct cache maintenance before using the buffer).
> > 
> > Thanks for that information, I believe a number of people in the
> > previous discussions were relying on the information from the
> > documentation. Are you sure that this is not only correct for the
> > cores made by ARM ltd but also for the other implementations that
> > may have relied on documentation?
> 
> It is a clarification in the ARM ARM so it covers all the cores made by
> architecture licensees, not just ARM Ltd. It basically makes the
> "unpredictable" part more predictable to allow certain types of aliases
> (e.g. Strongly Ordered vs Normal memory would still be disallowed).
> 
> All the current implementations are safe with Normal memory aliases
> (cacheable vs non-cacheable) but of course, there may be some
> performance benefits in not having any alias.

A lot of the discussions we are about to have in Budapest will be
around solving the problem of having only valid combinations of
mappings, so we really need to have a clear statement in specification
form about what is actually valid.

Would it be possible to have an updated version of the relevant
section of the ARM ARM by next week so we can use that as the
base for our discussions?

	Arnd
