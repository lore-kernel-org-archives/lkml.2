Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1HTEE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 00:04:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55493 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1HTEE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 00:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <1312826703.5589.155.camel@localhost.localdomain>
References: <1312826703.5589.155.camel@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 20 Aug 2011 00:04:07 -0400
Message-ID: <CAMjpGUeSTg_WYv7Pm2zaoRo0sLTzrPtwm_GobtXcuS7YAtQ3wg@mail.gmail.com>
Subject: Re: Missing put_cpu() in arch/ia64/sn/kernel/sn2/sn_hwperf.c?
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jes@sgi.com,
        tony.luck@intel.com, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 14:05, Thomas Meyer wrote:
>  Check for get/put_cpu() imbalances
>
>  The simplified semantic patch that makes this report is:
>
> * get_cpu()
> ... when != put_cpu()
> ? get_cpu()
>
> arch/blackfin/kernel/cplbinfo.c:89:9-10: WARNING: Possible missing put_cpu()!

the get_cpu() is in the seq_operations.start while the put_cpu() is in
the seq_operations.stop.  i believe this is OK and so this is a false
positive for blackfin.
-mike
