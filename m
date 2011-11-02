Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1KBIwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 04:52:13 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:40153 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752504Ab1KBIwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 04:52:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DnlzK0wVM1mYhuTgZpgZZGckpZvcVZxGxsus1CnfWI9QsW4
 OR_lHhN6PVcUCShpzX0GInWPYhTVm9e_1jT3QDmvie256WcBVYV5fbNtO1at
 yGLFDuATqID7tbX1SyQUlJz5H47amN9WRdSWOhpCiZjPxqCQAA81lO_fYbW9
 SGVNc7nhPrkkW0dI6P9G.FbWs7xTGGaIeKdMuibUKaOYQ1qU1cEczjkTxLk7
 ZaXugtdgi1jBE6ynrurAsFpeC9uYNUTPFAjQLVUjOYtiGidlV1UZMGCQp4Qk
 cGPibn4axbw5_HImsLMEuYs3wJOzGKyN6rY8Oa4buMs3vI3RYVL46HlI9xgf
 aOs9BB8MoE7h05gLigf5cHTBIBDNCWTC6eSHG1fFvKU981azYpJwDUEJMe6G
 uriJz.Gfgvv.vznfGDWDfoA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 2 Nov 2011 03:52:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if
 offstack
In-Reply-To: <CAOtvUMcHOysen7betBOwEJAjL-UVzvBfCf0fzmmBERFrivkOBA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111020351350.23788@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com> <1319385413-29665-7-git-send-email-gilad@benyossef.com> <alpine.DEB.2.00.1110272304020.14619@router.home> <CAOtvUMcHOysen7betBOwEJAjL-UVzvBfCf0fzmmBERFrivkOBA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, Gilad Ben-Yossef wrote:

> I think if it is up to me, I recommend going the simpler  route that
> does the allocation in flush_all using GFP_ATOMIC for
> CPUMASK_OFFSTACK=y and sends an IPI to all CPUs if it fails, because
> it is simpler code and in the end I believe it is also correct.

I support that. Pekka?

