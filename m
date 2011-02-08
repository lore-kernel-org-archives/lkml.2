Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1BHVKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:10:47 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57251 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755841Ab1BHVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:10:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VEl3F6hVa11HAn9z4jX1dNivF35GqoZFRWUzbb7k8V8xR9dVD7S2/U5EhfzFpe02/yytr2KKeoLUyTgOkhVSc7sboWGzqMckjKQ416mhRG84wFNaEvUB9+4po5epmLB0;
Date: Tue, 8 Feb 2011 13:10:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Avoid potential NULL pointer dereference in
 pci_scan_bridge
Message-ID: <20110208131043.3b1ca905@jbarnes-desktop>
In-Reply-To: <alpine.LNX.2.00.1101242108220.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101242108220.10252@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 21:14:33 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> pci_add_new_bus() calls pci_alloc_child_bus() which calls pci_alloc_bus() 
> that allocates memory dynamically with kzalloc(). The return value of 
> kzalloc() is the pointer that's eventually returned from 
> pci_add_new_bus(), so since kzalloc() can fail and return NULL so can 
> pci_add_new_bus(). Thus we may end up dereferencing a NULL pointer in 
> drivers/pci/probe.c::pci_scan_bridge(). Seems to me we should test for 
> this and bail out if it happens rather than crashing.
> Also removed some trailing whitespace that bugged me while looking at 
> this.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Applied to linux-next (in the absence of actual reports I'll be
conservative), thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
