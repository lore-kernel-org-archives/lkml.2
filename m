Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2JPTPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:15:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59494 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2JPTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:14:18 -0400
Date: Tue, 16 Oct 2012 12:14:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jesper Juhl <jj@chaosbits.net>
cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] [resend] ACPI: Fix memory leak in acpi_bind_one()
 (fwd)
In-Reply-To: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.00.1210161214001.4770@chino.kir.corp.google.com>
References: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, Jesper Juhl wrote:

> Memory is allocated with kzalloc() and assigned to
> 'physical_node'. Then 'physical_node->node_id' is initialized with a
> call to 'find_first_zero_bit()', if that results in a value greater
> than ACPI_MAX_PHYSICAL_NODE we'll end up jumping to the 'err:' label
> and there leave the function and let 'physical_node' go out of scope
> and leak the memory we allocated.
> This patch fixes the leak by simply freeing the unused/unneeded memory
> pointed to by 'physical_node' just before we jump to 'err:'.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: David Rientjes <rientjes@google.com>
