Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2GYRzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2GYRzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:55:44 -0400
Message-ID: <501032BF.1010800@redhat.com>
Date: Wed, 25 Jul 2012 13:54:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-5-git-send-email-walken@google.com>
In-Reply-To: <1342787467-5493-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:31 AM, Michel Lespinasse wrote:
> Introduce rb_insert_augmented(), which is a version of rb_insert_color()
> with an added callback on tree rotations. This can be used for insertion
> into an augmented tree: the handcoded search phase must be updated to
> maintain the augmented information on insertion, and then the rbtree
> coloring/rebalancing algorithms keep it up to date.
>
> rb_insert_color() is now a special case of rb_insert_augmented() with
> a do-nothing callback. I used inlining to optimize out the callback,
> with the intent that this would generate the same code as previously
> for rb_insert_augmented(). This didn't fully work, as my compiler output
> is now *smaller* than before for that function. Speed wise, they seem
> comparable though.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

The second version of patch 5/6 takes care of my
concerns about this patch.

Acked-by: Rik van Riel <riel@redhat.com>
