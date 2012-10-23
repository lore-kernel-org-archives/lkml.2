Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab2JWUbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:31:41 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:6001 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab2JWUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:31:05 -0400
Date: Tue, 23 Oct 2012 20:31:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at
 /proc/meminfo
In-Reply-To: <CALF0-+WASdSAT9rnLxx8OmHrNV5tjrDwpBTE9irCRd91QxMkBA@mail.gmail.com>
Message-ID: <0000013a8f524097-4ebaed3b-0d77-4183-a6ad-f01b8855f9bf-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com> <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com> <CALF0-+VqGrcjw16rNPH459YAj7dubQnruzV-zOzYn6feOtQ4tQ@mail.gmail.com>
 <0000013a8ed646c2-4cc34bd5-19c3-4e99-9fa0-248cdbc24feb-000000@email.amazonses.com> <CALF0-+WASdSAT9rnLxx8OmHrNV5tjrDwpBTE9irCRd91QxMkBA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Ezequiel Garcia wrote:

> The issue is: with SLUB large kmallocs don't set NR_SLAB_UNRECLAIMABLE
> zone item.
> Thus, they don't show at /proc/meminfo. Is this okey?

Yes. Other large allocations that are done directly via __get_free_pages()
etc also do not show up there. Slab allocators are intended for small
allocation and are not effective for large scale allocs. People will
use multiple different ways of acquiring large memory areas. So there is
no consistent accounting for that memory.


