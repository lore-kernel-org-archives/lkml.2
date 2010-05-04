Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab0EDTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:16:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16432 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022Ab0EDTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:16:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] vgacon: use request_region(), not request_resource(), to set BUSY
Date: Tue, 4 May 2010 13:16:50 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20100504185801.7244.39173.stgit@bob.kio> <20100504185806.7244.96960.stgit@bob.kio> <alpine.LFD.2.00.1005041207380.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005041207380.5478@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005041316.51113.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 04, 2010 01:09:46 pm Linus Torvalds wrote:
> On Tue, 4 May 2010, Bjorn Helgaas wrote:
> > Drivers normally use request_region() to mark the region busy so it won't
> > be used by anybody else.  Previously, we used request_resource(), which
> > doesn't mark the VGA regions busy.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Hmm. I don't object, but unless there is some crazy regression, there's no
> way I will take something like this outside the merge window. Who knows
> what odd frame buffer driver is out there that just depended on the fact
> that it could also register that VGA area?
> 
> Probably no such thing exists, but it's why I want these kinds of things
> during the merge window. And obviously preferably through something like
> the PCI merge tree, but that's a different issue.

Yep, I was intending for after .34.  I couldn't figure out where
to send it, but I'll be happy to send it to Jesse.

Bjorn
