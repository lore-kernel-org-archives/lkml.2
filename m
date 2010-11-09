Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0KIFvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:51:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33042 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0KIFvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:51:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=U2Ar0e7PnaikLlDqD9smOlhsCKabK7JUGOf9u8+R/E56vyLWUqItIDSHSevI4WzSXv
         jKssZPfJ47v3ccVCybPuFUiMwWEks9caL0cOe8ZytcVcsBdno8k0XhelVWqjFYus24jR
         1XAjGDH7Jk6LJTW1vRWplnLySdDM6POeCNleY=
MIME-Version: 1.0
In-Reply-To: <20101109142733.BC69.A69D9226@jp.fujitsu.com>
References: <AANLkTimXSSU7Mc05URg3HsONC4iyDTMVJdRxvQ1fNntH@mail.gmail.com> <20101109142733.BC69.A69D9226@jp.fujitsu.com>
From: Luke Hutchison <luke.hutch@gmail.com>
Date: Tue, 9 Nov 2010 00:50:40 -0500
Message-ID: <AANLkTikGC43B=+h5MNF665rFuRYfX4NQh6XyhuwxUT0A@mail.gmail.com>
Subject: Re: "BUG: soft lockup - CPU#0 stuck for 61s! [kswapd0:184]"
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 12:33 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> AFAIK, This isssue was already fixed by Mel.
>
> http://kerneltrap.org/mailarchive/linux-kernel/2010/10/27/4637977

Yes, based on where the CPU lockups were occurring
(zone_nr_free_pages, zone_watermark_ok), this fix does seem to address
the problem I described.  I assume the other lockup points
(_raw_spin_unlock_irqrestore, find_next_bit, sleeping_prematurely,
test_tsk_thread_flag) are also caused by the NR_FREE_PAGES problem?

Thank you for the link, I'll put it into the Fedora bug report and
hopefully a fix will be pushed out sometime soon.

Luke
