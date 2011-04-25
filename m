Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1DYS66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:58:58 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38659 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758810Ab1DYS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:58:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fiA2HHSlxeSOVylkX3W8EbgXtiZW1Y3NsMrUP9MXxh100Kgti5HRgXku5Tz/WSMJCAO/uKLX01+ytwKy/xKX4S2oCI7wGxtNRHUIl+TCQTvt06Cc4A+5okmjXE1gjLSl;
Date: Mon, 25 Apr 2011 11:58:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad@kernel.org
Subject: Re: [PATCH v6] xen pci backend driver.
Message-ID: <20110425115850.48b7d254@jbarnes-desktop>
In-Reply-To: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
References: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 17:07:19 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> The following patch implements the Xen pci backend for upstream Linux.
> This is the host side counterpart to the frontend driver in
> drivers/pci/xen-pcifront.c. The PV protocol is also implemented by
> frontend drivers in other OSes too, such as the BSDs.
> 
> This driver has a long history as an out of tree driver but I am
> submitting it here as a single monolithic patch to aid review. Once it
> has been reviewed and is considered suitable for merging can we perhaps
> consider merging the equivalent git branch which maintains much of
> history?

It looks pretty clean at first glance (though 128k worth of patch isn't
an ideal way to split it).

But maybe the back end belongs in arch/x86/xen as it's really a arch
specific PCI implementation at heart?  I don't want to be a bottleneck
for any Xen specific PCI patches in the future, and other arches have a
similar split (though not always with an ideal core vs arch split).

Figuring out some way to preserve the git history is probably a good
idea, assuming it's not too much of a mess.  If it is, a more
reasonable split and history using rebase could probably be contrived
before merging it.

-- 
Jesse Barnes, Intel Open Source Technology Center
