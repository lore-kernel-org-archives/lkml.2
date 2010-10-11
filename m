Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0JKWFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:05:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab0JKWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=J1nj3DMSwlLWJNc/KQaqUuqnQ3hSLHg5CP55+hyLhpyzD4aMQCPjLM69klzbq8ttkX
         RUffEqetEyCn7d37ogWg==
Date: Mon, 11 Oct 2010 15:05:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, rja@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, numa: For each node, register the memory
 blocks actually used
In-Reply-To: <tip-e9aeb8fdb6b197b9b1e1c49717de892593bb811e@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1010111504450.5358@chino.kir.corp.google.com>
References: <4CB27BDF.5000800@kernel.org> <tip-e9aeb8fdb6b197b9b1e1c49717de892593bb811e@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, tip-bot for Yinghai Lu wrote:

> Commit-ID:  e9aeb8fdb6b197b9b1e1c49717de892593bb811e
> Gitweb:     http://git.kernel.org/tip/e9aeb8fdb6b197b9b1e1c49717de892593bb811e
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Sun, 10 Oct 2010 19:52:15 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 11 Oct 2010 13:46:34 -0700
> 
> x86, numa: For each node, register the memory blocks actually used
> 
> Russ reported SGI UV is broken recently. He said:
> 
> | The SRAT table shows that memory range is spread over two nodes.
> |
> | SRAT: Node 0 PXM 0 100000000-800000000
> | SRAT: Node 1 PXM 1 800000000-1000000000
> | SRAT: Node 0 PXM 0 1000000000-1080000000
> |
> |Previously, the kernel early_node_map[] would show three entries
> |with the proper node.
> |
> |[    0.000000]     0: 0x00100000 -> 0x00800000
> |[    0.000000]     1: 0x00800000 -> 0x01000000
> |[    0.000000]     0: 0x01000000 -> 0x01080000
> |
> |The problem is recent community kernel early_node_map[] shows
> |only two entries with the node 0 entry overlapping the node 1
> |entry.
> |
> |    0: 0x00100000 -> 0x01080000
> |    1: 0x00800000 -> 0x01000000
> 
> After looking at the changelog, Found out that it has been broken for a while by
> following commit
> 
> |commit 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
> |Author: David Rientjes <rientjes@google.com>
> |Date:   Fri Sep 25 15:20:04 2009 -0700
> |
> |    x86: Export srat physical topology
> 
> Before that commit, register_active_regions() is called for every SRAT memory
> entry right away.
> 
> Use nodememblk_range[] instead of nodes[] in order to make sure we
> capture the actual memory blocks registered with each node.  nodes[]
> contains an extended range which spans all memory regions associated
> with a node, but that does not mean that all the memory in between are
> included.
> 
> Reported-by: Russ Anderson <rja@sgi.com>
> Tested-by: Russ Anderson <rja@sgi.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> LKML-Reference: <4CB27BDF.5000800@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: <stable@kernel.org> 2.6.33 .34 .35 .36
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>

Sorry I hadn't seen this thread earlier, I wasn't cc'd on it.
