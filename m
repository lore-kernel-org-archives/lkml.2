Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1JOA21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:28:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:51730 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab1JOA20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:28:26 -0400
Date: Sat, 15 Oct 2011 11:28:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
In-Reply-To: <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com> <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:

> +MPI mpi_alloc(unsigned nlimbs)
> +{
> +	MPI a;
> +
> +	a = (MPI) kmalloc(sizeof *a, GFP_KERNEL);

Generally, typedef structs are frowned upon in the kernel.  I'd prefer to 
see this (and any others) changed to a normal type.

Also, kmalloc return values do not need to be cast, they're void *.

> +EXPORT_SYMBOL(mpi_alloc);

New interfaces should be EXPORT_SYMBOL_GPL.


-- 
James Morris
<jmorris@namei.org>
