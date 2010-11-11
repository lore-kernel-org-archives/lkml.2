Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0KKMJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:09:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61320 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0KKMJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M8dwWVJue3J9cH3Zsckqenr311kzdpbwmj9nuC+suKmUVwooI+uj88YBPJmeVWcK2a
         zeGtlhYXUY9ckM6qsV7LLLOn9c6PTvrZr9E977u0xh9nyjn1zLXgHiNRCSZgtpl1F3eX
         1HqXcPf8uN2DF16XtWB2oRD6ABzg0NqX4P054=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-10-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-10-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 14:09:46 +0200
X-Google-Sender-Auth: Bb8sPIixt-R5ewKasMnr-l5V9H0
Message-ID: <AANLkTi=Hoa20zPcBg4g+cp_hsini0ASB9w2TQNWZYhMw@mail.gmail.com>
Subject: Re: [PATCH 9/9] x86: Unify NUMA initialization between 32 and 64bit
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
> Now that everything else is unified, NUMA initialization can be
> unified too.
>
> * numa_init_array() and init_cpu_to_node() are moved from numa_64 to
>  numa.
>
> * numa_32::initmem_init() is updated to call numa_init_array() and
>  setup_arch() to call init_cpu_to_node() on 32bit too.
>
> * x86_cpu_to_node_map is now initialized to NUMA_NO_NODE on 32bit too.
>  This is safe now as numa_init_array() will initialize it early
>  during boot.
>
> This makes NUMA mapping fully initialized before setup_per_cpu_areas()
> on 32bit too and thus makes the first percpu chunk which contains all
> the static variables and some of dynamic area allocated with NUMA
> affinity correctly considered.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
