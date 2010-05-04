Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab0EDTLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:11:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932993Ab0EDTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:11:18 -0400
Date: Tue, 4 May 2010 12:09:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] vgacon: use request_region(), not request_resource(),
 to set BUSY
In-Reply-To: <20100504185806.7244.96960.stgit@bob.kio>
Message-ID: <alpine.LFD.2.00.1005041207380.5478@i5.linux-foundation.org>
References: <20100504185801.7244.39173.stgit@bob.kio> <20100504185806.7244.96960.stgit@bob.kio>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 May 2010, Bjorn Helgaas wrote:
> 
> Drivers normally use request_region() to mark the region busy so it won't
> be used by anybody else.  Previously, we used request_resource(), which
> doesn't mark the VGA regions busy.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Hmm. I don't object, but unless there is some crazy regression, there's no 
way I will take something like this outside the merge window. Who knows 
what odd frame buffer driver is out there that just depended on the fact 
that it could also register that VGA area?

Probably no such thing exists, but it's why I want these kinds of things 
during the merge window. And obviously preferably through something like 
the PCI merge tree, but that's a different issue.

		Linus
