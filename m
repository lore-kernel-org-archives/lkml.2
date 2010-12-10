Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0LJUcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:32:08 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41953 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756383Ab0LJUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:32:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=helmdpi8UzWxvalJqNMRojKTBbDexwekPCJNdF7sR2fAxPVLHxKEfZuRNSg4e/TfL/S+O4skzOEV0odTAkryjtJMvQKP1gVkJqnzj4HvurSQRBWAIM/gUt5xMiMNrnOt;
Date: Fri, 10 Dec 2010 12:32:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] Update MCP55 quirk to not affect non HyperTransport
 variants
Message-ID: <20101210123203.3b3b9c1c@jbarnes-desktop>
In-Reply-To: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
References: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Dec 2010 09:47:48 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> I wrote this quirk awhile ago to properly setup MCP55 chips on hypertransport
> busses so that interrupts reached whatever cpu happend to boot the kdump kernel.
> while that works well, it was recently shown to me that a a non-hypertransport
> variant of the MCP55 exists, and on those system the register that this quirk
> manipulates causes hangs if you write to it.  Since the quirk was only meant to
> handle errors found on MCP55 chips that have a HT interface, this patch adds a
> filter to make sure the chip is an HT capable before making the needed register
> adjustment.  This lets the broken MCP55s work with kdump while not breaking the
> non-HT variants.
> 
> Resolves https://bugzilla.kernel.org/show_bug.cgi?id=23952
> 
> Tested successfully by the reporter and myself.

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
