Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0LHPdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:33:45 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:40580 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755313Ab0LHPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:33:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9KvPqsIVM1kGI_2At0a2UlZOfjzI4Mc6eqE.LPAHIM5xeMG
 OdmbDDjus96f8eubpPCPd7dP7ZLsorVxYpsQOzRLgRZ_6yQ26g749dpfAaAC
 c8FHjU8nDaoqAZapOy2VvqDpPml0RYQj98rdeTA3B8BAxNEO8GrNgqQdEcMi
 GSDYnewC3ueBOVw05cIOJJUzOGUu_O7w0xOUieYYWfBOF0osmgMaU2HFf5C4
 7FLP4sX1Csg4SCSMaLHfw59lmRl_gyghEH2BBgdE-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 09:33:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu
 ops
In-Reply-To: <1291815501.2883.34.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1012080929590.23407@router.home>
References: <20101206171618.302060721@linux.com>  <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>  <4CFE4294.30001@kernel.org>  <alpine.DEB.2.00.1012070846050.25976@router.home>  <4CFE4BE0.9040203@kernel.org>  <alpine.DEB.2.00.1012070906290.26552@router.home>
  <4CFE4E05.7070902@kernel.org>  <alpine.DEB.2.00.1012071020040.26552@router.home>  <4CFF8520.4020704@kernel.org> <1291815501.2883.34.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Eric Dumazet wrote:

> > In the long run, it might be a good idea to remove cpu_data() macro
> > too and use per_cpu macro directly.
> >
>
> or introduce this_cpu_has() to remove the adress computation
>
> -	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
>
> +	if (this_cpu_has(X86_FEATURE_ARAT)) {
>

The fundamental problem is that bitops require memory addresses which does
not work with per cpu ops.

