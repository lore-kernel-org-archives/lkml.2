Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2EJVmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:42:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49679 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761589Ab2EJVml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	<CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
Date: Thu, 10 May 2012 14:42:41 -0700
Message-ID: <CAH+dOxKy-ioqcWnsyfnfPJACcBu=qgWa0mUHnD_ekZevBePQ_Q@mail.gmail.com>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
From: Kent Overstreet <koverstreet@google.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, grepped around but missed that. Thanks.

On Thu, May 10, 2012 at 12:35 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, May 9, 2012 at 8:10 PM, Kent Overstreet <koverstreet@google.com> wrote:
>> Much of this code should be moved out of drivers/block/bcache, but it
>> was originally written for bcache.
>>
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>> ---
>
> [..]
>> +#include <linux/dynamic_fault.h>
> [..]
>> +#define bio_alloc_pages(...)                                           \
>> +       (dynamic_fault() ? -ENOMEM      : bio_alloc_pages(__VA_ARGS__))
>> +
>
> ...these missed the removal of the dynamic_fault bits.
