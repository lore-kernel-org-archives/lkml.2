Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab2EPSk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:40:26 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:54684 "HELO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754240Ab2EPSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205141352440.26304@router.home>
References: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
	<alpine.DEB.2.00.1205141352440.26304@router.home>
Date: Wed, 16 May 2012 11:40:21 -0700
Message-ID: <CALnjE+r2OQ5YmpCjDS09uQ5B2jMEWCF3V7NbZ0Q6jGwVhoZS9Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix slab->page flags corruption.
From: Pravin Shelar <pshelar@nicira.com>
To: andrea@qumranet.com, aarcange@redhat.com
Cc: penberg@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jesse@nicira.com, abhide@nicira.com,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:53 AM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 14 May 2012, Pravin B Shelar wrote:
>
>> Transparent huge pages can change page->flags (PG_compound_lock)
>> without taking Slab lock. Since THP can not break slab pages we can
>> safely access compound page without taking compound lock.
>>
>> Specificly this patch fixes race between compound_unlock and slab
>> functions which does page-flags update. This can occur when
>> get_page/put_page is called on page from slab object.
>
> You need to also get this revbiewed by the THP folks like Andrea &
> friends.

Hi Andrea,

Can you comment on this patch.

Thanks.

>
> Reviewed-by: Christoph Lameter <cl@linux.com>
