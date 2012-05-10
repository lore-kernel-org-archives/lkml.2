Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561Ab2EJTf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:35:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41395 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab2EJTf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
Date: Thu, 10 May 2012 12:35:25 -0700
X-Google-Sender-Auth: 1Hhimd-LeNVwns_ajw_LAXIB4-0
Message-ID: <CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
From: Dan Williams <dan.j.williams@intel.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 8:10 PM, Kent Overstreet <koverstreet@google.com> wrote:
> Much of this code should be moved out of drivers/block/bcache, but it
> was originally written for bcache.
>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---

[..]
> +#include <linux/dynamic_fault.h>
[..]
> +#define bio_alloc_pages(...)                                           \
> +       (dynamic_fault() ? -ENOMEM      : bio_alloc_pages(__VA_ARGS__))
> +

...these missed the removal of the dynamic_fault bits.
