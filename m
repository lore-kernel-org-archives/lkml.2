Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab2KNVzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:55:06 -0500
Received: from 173-254-64-10.unifiedlayer.com ([173.254.64.10]:60196 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S933125Ab2KNVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:55:04 -0500
Date: Wed, 14 Nov 2012 13:55:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/Sandy Bridge: reserve pages when integrated
 graphics is present
Message-ID: <20121114135534.653b70dd@jbarnes-desktop>
In-Reply-To: <20121114211905.503f3701@pyramind.ukuu.org.uk>
References: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
	<20121114211905.503f3701@pyramind.ukuu.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 21:19:05 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 14 Nov 2012 20:43:31 +0000
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > SNB graphics devices have a bug that prevent them from accessing certain
> > memory ranges, namely anything below 1M and in the pages listed in the
> > table.  So reserve those at boot if set detect a SNB gfx device on the
> > CPU to avoid GPU hangs.
> 
> What happens if the other addresses map to an external memory object - eg
> a PCI device which is a legitimate DMA source for video overlay etc ?

Other addresses as in the 5 pages high in the address space?  I'm not
sure how to do what I want with memblock, doesn't it just allocate RAM
not I/O space?... /me looks at the memblock API

Or do you mean if we map GTT pages to point at some non-RAM region will
SNB gfx be able to decode them?  If that's the question, then I think
the answer is no, but I don't have enough detail on the hw bug to be
certain.

> I assume this is just for GPU fetches from main memory ?

AIUI, it's an address decoder bug, so it would affect any fetch by the
GPU through its memory interface glue.

-- 
Jesse Barnes, Intel Open Source Technology Center
