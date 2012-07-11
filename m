Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2GKGj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:39:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2GKGj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:39:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/slob: avoid type warning about alignment value
Date: Wed, 11 Jul 2012 06:39:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
References: <201207102055.35278.arnd@arndb.de> <alpine.DEB.2.00.1207101815580.684@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1207101815580.684@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207110639.43587.arnd@arndb.de>
X-Provags-ID: V02:K0:XQMm7PHE8XyfhIe+NZNWoie6qE6EpkLbWr6D0bATiS5
 dkxu1kb3nGTQ+/O43aO8pKdP+d/552W0aKSgB1xIqZ2RaWRbLl
 zmvtL4niZs4dnNM3D4yysmGqV283It+esLLmLpeBYY/k5Skexs
 7+LmzWrc6z4UwqZJ7tZ37I/kFm8I9yQ9X6Cg4SnkwdOlZ47+Oi
 18N6wXzN1NMRe6Sh6dskp5d7054U3vGlbWYCeK+G2FIBXKGWzg
 NrRrhsA/qMK5mbT/Ea9qjy7TTah72fj8TbkJgJ1qr/CL9AC73o
 Jm9KrKyPELlbFQ6bY90iZyHfbS7CfM6TNbcDS9UwUIuUxbkMsV
 3BzNOD2hKvWoIHxyg2iI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012, David Rientjes wrote:
> Wouldn't it be better to avoid this problem more generally by casting the 
> __alignof__ for ARCH_{KMALLOC,SLAB}_MINALIGN to int in slab.h?  All 
> architectures that define these themselves will be using plain integers, 
> the problem is __alignof__ returning size_t when undefined.

I thought about it but I wasn't sure if that would cover all possible
cases. My version at least is known not to introduce a different type
mismatch on another architecture.

Also, size_t seems to be the correct type here, while the untyped
definition is just an int.

	Arnd
