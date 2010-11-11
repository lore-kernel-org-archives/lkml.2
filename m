Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0KKMLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:11:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42635 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0KKMLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GP3YPV6KSdvVT4siiYzpkknSXB/a2zezNYLXF8sCts0FzuZPHmGPkwnx+WrKbCbrnb
         mf2TOYLMrmayxT6SZMKXMSEnIYRMVBVqczb6jLKRwsZySqOc+IQAEdN24YsjTOVqnpPr
         5zHwffbsLDoRrU6NHeiK8DYmFcHOFR0LL2TbI=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-9-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-9-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 14:11:23 +0200
X-Google-Sender-Auth: aXcdx7sVuQlO_lrt_8pHS3gkroQ
Message-ID: <AANLkTik+AvDwHMK-xAT48T2NL3vm65NTxU4h0ucF3g9g@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: Unify node_to_cpumask_map handling between 32
 and 64bit
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> x86_32 has been managing node_to_cpumask_map explicitly from
> map_cpu_to_node() and friends in a rather ugly way.  With previous
> changes, it's now possible to simply share the code with 64bit.
>
> * numa_add/remove_cpu() are moved from numa_64 to numa.
>
> * identify_cpu() now calls numa_add_cpu() for 32bit too.  This makes
>  the explicit mask management from map_cpu_to_node() unnecessary.
>
> * The whole x86_32 specific map_cpu_to_node() chunk is no longer
>  necessary.  Dropped.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
