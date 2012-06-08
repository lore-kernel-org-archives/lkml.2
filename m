Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2FHTEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:04:53 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:44584 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753211Ab2FHTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:04:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Kvi8gvQVM1lwSONhOZjmrVvp.9_5ishHvGd4_1TDI5Tfv.N
 GN1azq_nmna2YrbnbyfvvO6SQdX.wfvst5JnXb3CazeYdOu3Xi1KEuryT8Kj
 _cJOkvlnnpuYzAqciM2AACcTaEhyOW_HxQroTl0AX_uN3JT7aJ6QnvWuMtms
 DgmJCzd8IzDsseqqsPys2Xk.DBZGt.lTUON1kln_57FeT1uraTAAqkxIZ0rh
 VGpe.Jl4RztsGYk5s4JJe_ddhYl0BDMWeOUxvp9jfh.QpJ.XR.PDywoiiBfR
 gLTU1vmTetKeoUKuNBHUbzDFjtrDWbdiVKamFHEAlfGon7oHg_3x.WuuvoCH
 A4lfLhV0d.6tQArP0em0AVOj68N4_RacMMWLm4WyYRgksVgyd58W.Zsp2vRg
 yBWpmeWTr9yLExERMlowfbD8.fOgAWNzmmYHI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 8 Jun 2012 14:04:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/4] slub: deactivate freelist of kmem_cache_cpu all at
 once in deactivate_slab()
In-Reply-To: <1339176197-13270-4-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1206081403380.28466@router.home>
References: <yes> <1339176197-13270-1-git-send-email-js1304@gmail.com> <1339176197-13270-4-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Joonsoo Kim wrote:

> Current implementation of deactivate_slab() which deactivate
> freelist of kmem_cache_cpu one by one is inefficient.
> This patch changes it to deactivate freelist all at once.
> But, there is no overall performance benefit,
> because deactivate_slab() is invoked infrequently.

Hmm, deactivate freelist can race with slab_free. Need to look at this in
detail.


