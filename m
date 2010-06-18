Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0FRBkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 21:40:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40777 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0FRBkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 21:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g1tu0jIY1w+EtcvWyQj2uEQVA4D69Bxn2voyZbMofq/obxRolKKrWZD6O8LC5Hte/s
         cBMg9LgKrLZn8bgaCESRYtH3v7/n6S0tfXQFn1vyedpV512abeKqgi9UopPvh7an2eFE
         H7ZGlk2cplYQJHhjegPvOp7AdEyaxsr1I8UxE=
MIME-Version: 1.0
In-Reply-To: <1276818988.9661.80.camel@schen9-DESK>
References: <1276818988.9661.80.camel@schen9-DESK>
Date: Fri, 18 Jun 2010 10:40:02 +0900
Message-ID: <AANLkTinxkt_ttN68cLFqS8ubqpyQATIbtRMlILK10g69@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] tmpfs: Improve tmpfs scalability
From: Minchan Kim <minchan.kim@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
       yanmin.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 8:56 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> This patch series helps to resolve scalability problem
> for tmpfs.  With these patches, Aim7 fserver throughput for tmpfs
> improved by 270% on a 4 socket, 32 cores NHM-EX system.
>
> In current implementation of tmpfs, whenever we
> get a new page, stat_lock in shmem_sb_info needs to be acquired.
> This causes a lot of lock contentions when multiple
> threads are using tmpfs simultaneously, which makes
> system with large number of cpus scale poorly.
> Almost 75% of cpu time was spent contending on
> stat_lock when we ran Aim7 fserver load with 128 threads
> on a 4 socket, 32 cores NHM-EX system.
>
> We made use of the percpu_counter library for used blocks accounting to
> speed up the getting and returning of blocks to local per cpu counter
> without lock acquisition.
>
> The first patch in the series add a function to provide
> fast but accurate comparison for the percpu_counter library.
>
> The second patch update the shmem code of tmpfs to use percpu_counter
> library to improve tmpfs performance.
>

Patch series seems good to me.

If you send a patch, please, make sure Cc list.
tmpfs is related to mm. So when you send patch at next time, please Cc linux-mm.

You can use ./script/get_maintainer.pl -f mm/shmem.c

Thanks.
-- 
Kind regards,
Minchan Kim
