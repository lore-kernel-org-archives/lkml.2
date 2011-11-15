Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1KOPy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:54:58 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:22688 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756349Ab1KOPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:54:57 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jBaFw_kVM1nwnkWrNp1qvaoGcn2RHT2u96c0CFL0RGJX1D2
 ixpx95hXwC9pRHvUKIHn18vIOlmxHTdSyHB8MYcFmsus9erKziQcyz0Prrd_
 fCVrhO47ABlBAGpF4GqXIW2iUB8BRJ4bHCPgdBXWn4jilqTITOgmI_NFgGUh
 Ad8vIqxKByGh9id_rI0ncz6K7xyMjIzrRZF7zpRExZc3.2EaED8S3KiRqWeN
 n.m4oFBnhyY_2DOWyQ85SMjeGOxnbUc5FX0Jya.Jp7G6gVSNtMBzMBntSyYE
 pJTcYDJSiPKO6zLVY0tkAT_sDBR7xwtKWKrufuPwS7hhQAeJkte0SC_2H6Bf
 ZJaXKJUa2JJ.FaBcr33lYi6gL_v6raIIu8.5cYhLeum2i_OM7mIYBytHj.8m
 DSMBzv_3sl0ODTqo_mtny
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 Nov 2011 09:54:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 4/5] slub: Only IPI CPUs that have per cpu obj to
 flush
In-Reply-To: <1321179449-6675-5-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1111150953460.22502@router.home>
References: <1321179449-6675-1-git-send-email-gilad@benyossef.com> <1321179449-6675-5-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011, Gilad Ben-Yossef wrote:

> @@ -2006,7 +2006,20 @@ static void flush_cpu_slab(void *d)
> +	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
> +		for_each_online_cpu(cpu) {
> +			c = per_cpu_ptr(s->cpu_slab, cpu);
> +			if (c && c->page)

c will never be null. No need to check.

Otherwise

Acked-by: Christoph Lameter <cl@linux.com>

