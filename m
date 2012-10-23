Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2JWVeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:34:07 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:52361 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab2JWVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:34:06 -0400
Date: Tue, 23 Oct 2012 21:34:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tim Bird <tim.bird@am.sony.com>
cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at
 /proc/meminfo
In-Reply-To: <508705BE.2020403@am.sony.com>
Message-ID: <0000013a8f8bed5f-050d67ef-e37b-42aa-b576-9a08a74bff16-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com> <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com> <CALF0-+VqGrcjw16rNPH459YAj7dubQnruzV-zOzYn6feOtQ4tQ@mail.gmail.com>
 <0000013a8ed646c2-4cc34bd5-19c3-4e99-9fa0-248cdbc24feb-000000@email.amazonses.com> <CALF0-+WASdSAT9rnLxx8OmHrNV5tjrDwpBTE9irCRd91QxMkBA@mail.gmail.com> <0000013a8f524097-4ebaed3b-0d77-4183-a6ad-f01b8855f9bf-000000@email.amazonses.com>
 <508705BE.2020403@am.sony.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Tim Bird wrote:

> There's a certain irony here.  In embedded, we get all worked
> up about efficiencies in the slab allocators, but don't have a good
> way to track the larger memory allocations.  Am I missing
> something, or is there really no way to track these large
> scale allocations?

We could use consistent allocator calls everywhere. But these
large allocators are rather rare. And sometimes we need pointers to page
structs and other times we use pointers to the raw memory.

