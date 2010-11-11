Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0KKMBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:01:38 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43590 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0KKMBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V3HA50AKVcrzVtpSChqlXhSyAJ27uoegcbs3f3G6C8UqUg5HBoOOvhMEucXkmh8BxT
         XylcNTO9wioHbeZXTO0MwLsd+lskjLmLPZb/w9zr0ZZ24KfurkbtYeYB557JiQfxa4+L
         jXow3/o5zkOAuoI6GpBFcd1BOw9a3l8NbPp3I=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-7-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-7-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 14:01:36 +0200
X-Google-Sender-Auth: 4v5eJ7WtLXA8K6l5dkH1wtoa5nk
Message-ID: <AANLkTimLimZqmneezs_UBvDYmoK_YUd0fHKMtkUyggp=@mail.gmail.com>
Subject: Re: [PATCH 6/9] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
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
> The mapping between cpu/apicid and node is done via apicid_to_node[]
> on 64bit and apicid_2_node[] + apic->numa_cpu_node() on 32bit.  This
> difference makes it difficult to further unify 32 and 64bit NUMA
> hanlding.
>
> This patch unifies it by replacing both apicid_to_node[] and
> apicid_2_node[] with __apicid_to_node[] array, which is accessed by
> two accessors - set_apicid_to_node() and numa_cpu_node().  On 64bit,
> numa_cpu_node() always consults __apicid_to_node[] directly while
> 32bit goes through apic->numa_cpu_node() method to allow apic
> implementation to override it.
>
> There are several places where using numa_cpu_node() is awkward and
> the override doesn't matter.  In those places, __apicid_to_node[] are
> used directly.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
