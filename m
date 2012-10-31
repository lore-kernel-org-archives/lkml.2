Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2JaG4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:56:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55722 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2JaG4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <5085370F.80204@parallels.com>
References: <1350907471-2236-1-git-send-email-elezegarcia@gmail.com>
	<5085370F.80204@parallels.com>
Date: Wed, 31 Oct 2012 08:56:15 +0200
X-Google-Sender-Auth: 19DZ8-31XT1FeZVgwL1hq_-bS1Y
Message-ID: <CAOJsxLGSyBx=VkQ1vjAwYMNgfKR3inWRpkTWTYkWnhzHsVPD_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/slob: Use free_page instead of put_page for
 page-size kmalloc allocations
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 10/22/2012 04:04 PM, Ezequiel Garcia wrote:
>> When freeing objects, the slob allocator currently free empty pages
>> calling __free_pages(). However, page-size kmallocs are disposed
>> using put_page() instead.
>>
>> It makes no sense to call put_page() for kernel pages that are provided
>> by the object allocator, so we shouldn't be doing this ourselves.
>>
>> This is based on:
>> commit d9b7f22623b5fa9cc189581dcdfb2ac605933bf4
>> Author: Glauber Costa <glommer@parallels.com>

On Mon, Oct 22, 2012 at 3:07 PM, Glauber Costa <glommer@parallels.com> wrote:
> Acked-by: Glauber Costa <glommer@parallels.com>

Applied, thanks Ezequiel!
