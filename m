Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0CRPfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:35:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38712 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0CRPfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Mar 2010 09:35:30 -0600
X-Google-Sender-Auth: 4bd1a92b854a2543
Message-ID: <fa686aa41003180835k5af2d0e4o11f8ab9ca2e905ed@mail.gmail.com>
Subject: Re: [V2 PATCH 00/10] of: Consolidate scattered device node pointers 
	in struct device
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 9:22 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Currently, each of_device has a copy of the device tree node pointer in both
> .node, and in .dev.archdata.of_node (microblaze and powerpc) or
> .dev.archdata.prom_node (sparc).  Also, other architectures will be adding
> CONFIG_OF support, and they will also need a reference to the device tree
> node pointer from struct device.
>
> This series consolidates the device node pointer by adding .of_node to
> struct device (conditional on CONFIG_OF) and removing the archdata.of_node,
> archdata.prom_node and of_device.node users.  The pointer is moved out of
> dev_archdata and into struct device proper so that of_node doesn't need to
> get manually added to archdata for each architecture that enables CONFIG_OF.

This series is also available in my git tree:

git://git.secretlab.ca/git/linux-2.6 experimental-devicetree
