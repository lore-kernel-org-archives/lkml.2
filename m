Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0K0IBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:01:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59749 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0K0IA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wUQ7MBAtL8NNyI0R2C3JT0YmcYiGfpDNCfZNFC36PZKvEoTwdo583McgQITJ+j5hCf
         ooJUVEKbkZOrLGhL0cCWHmEZnI58ORIYVCFmja+m9KlSwmebhkPsR6RjVgi0R4ifmqEH
         FIZwLq0xzvm7YBXuHEtYJ0enCfGpqgfwMaLEA=
MIME-Version: 1.0
In-Reply-To: <20101126210950.142747403@linux.com>
References: <20101126210937.383047168@linux.com>
	<20101126210950.142747403@linux.com>
Date: Sat, 27 Nov 2010 10:00:58 +0200
X-Google-Sender-Auth: 5Hk9Pw92Xuj0pjMYOtwJG3Pqs2U
Message-ID: <AANLkTinjh=A52zoWvWT1e2j8VJ65t50ss7jCODgcMPS_@mail.gmail.com>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> this cpu operations can be used to slightly optimize the function. The
> changes will avoid some address calculations and replace them with the
> use of the percpu segment register.
>
> If one would have this_cpu_inc_return and this_cpu_dec_return then it
> would be possible to optimize inc_zone_page_state and dec_zone_page_state even
> more.
>
> V1->V2:
>        - Fix __dec_zone_state overflow handling
>        - Use s8 variables for temporary storage.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
