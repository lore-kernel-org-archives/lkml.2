Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967552Ab2EQSbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:31:01 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39768 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967515Ab2EQSa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:30:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: t4C.UbcVM1koJ7iQpJvyA3B2ppzO8igv3SbsB4V57ycNoqN
 m8wyauJ0DaqguitPLPVdTKTScGU9PgrEq7u0gZg1cDZ80bcDM2F76diOCXIC
 m3e0Vel8YWPtZAag6xnDa3t9Y08C7UhJpxEHgy2SWcbCoZVK8dWk6x48Hnd9
 cnrVxYjRD4_38.HjbY9qy3MPn2nDn.68qa13E4l7V6AAB8nYCM7DedOejjvG
 A3iIRhL2xqz_qkQm.yx8ddC5xBALVKN_prVo2vsFNU2oPDLFrRT_uCrPO70K
 SUlJto5GHjpUtlHp_sJiuPqpQoVgiou1ddIRcg_zDBBixcKJQzPkYgpmxTet
 zn3iCzJd8pO5M1ao7svakQFNuZaDX1AIlmuFdKvk4hg02g1A2M48eXspjFgj
 ewuo0jsG07gXeTdkGp16E4RivRsqyM.ziSHfn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 17 May 2012 13:30:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/4] slub: refactoring unfreeze_partials()
In-Reply-To: <1337269668-4619-5-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205171329440.12366@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337269668-4619-5-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> I think that these are disadvantages of current implementation,
> so I do refactoring unfreeze_partials().

The reason the current implementation is so complex is to avoid races. The
state of the list and the state of the partial pages must be consistent at
all times.

> Minimizing code in do {} while loop introduce a reduced fail rate
> of cmpxchg_double_slab. Below is output of 'slabinfo -r kmalloc-256'
> when './perf stat -r 33 hackbench 50 process 4000 > /dev/null' is done.

Looks good. If I can convince myself that this does not open up any
new races then I may ack it.
