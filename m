Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1FFVw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:52:58 -0400
Received: from mail.perches.com ([173.55.12.10]:2540 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab1FFVwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:52:55 -0400
Subject: [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>, cocci <cocci@diku.dk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
        vinod.koul@intel.com
In-Reply-To: <201106061349.00474.hartleys@visionengravers.com>
References: <201106061349.00474.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 14:52:54 -0700
Message-ID: <1307397174.4994.26.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 13:49 -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dan Williams <dan.j.williams@intel.com> (supporter:ASYNCHRONOUS TRAN...)
> Cc: Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO...)

Perhaps do a treewide update via:

$ cat resource.cocci
@@
struct resource *ptr;
@@

- ptr->end - ptr->start + 1
+ resource_size(ptr)

$ spatch -sp_file resource.cocci linux-2.6/


