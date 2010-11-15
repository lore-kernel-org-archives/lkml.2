Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0KOVIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:08:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:42022 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab0KOVIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:08:39 -0500
Subject: Re: [PATCH 00/20] x86: ticket lock rewrite and paravirtualization
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <4CE19FD1.2000804@goop.org>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <4CDDBBD3.5050903@zytor.com> <4CDDBCE4.80906@goop.org>
	 <4CDDBDB5.8000800@zytor.com> <4CE1915F.60507@goop.org>
	 <4CE1920F.5000509@zytor.com> <1289852088.2109.553.camel@laptop>
	 <4CE19FD1.2000804@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 22:08:32 +0100
Message-ID: <1289855312.2109.555.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 13:02 -0800, Jeremy Fitzhardinge wrote:
> 
> As a heuristic, it shouldn't be too bad performancewise, since
> (handwaving) if ticketholder N has entered the slowpath, then its likely
> that N+1 will as well. 

Yes, esp. if the whole slow unlock path takes more cycles than you spin
for to begin with.

I think this approach is definitely worth trying.
