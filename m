Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2FEPGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:06:10 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:44685 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751212Ab2FEPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:06:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: z.LJZ6AVM1n3pgd7yTrmZR9q2yqre4WyOSHsLLK_A06q7N5
 jyG6h5EH_GHv1q79JB30wvEOe5ZhrQuvA.SrPVk8w.nNHdAT_L7Oiecu.pSh
 t.52.vhk15aaixOJZUAIciZhPtZEqaJaAKu6hDV0PZwYiahOdiU3A.D.6Ku1
 If6YALpNiDW9ewYxrlnn2dV8XLcGABqONkihm.yCu1ocj6OHyWkYRUMzGS6N
 4YjUtiQO3QdcCx_qJ8r60APT4sS13oG_coVgTe5mkS_JBV63DwWs9wAqlFpw
 7GkBfw..4u3n.q9M4bg8vXtrFThEVk4WGD8PXJLhGYwJ0_ZilHulR7i55nEM
 cgEK1K.vM3SbgF6AFSgsShEs5bATfVetyDBGfedw2UNyf_YfhsZZ5pfCZ66o
 hEZoZ_NXorMGg.Do_lADZ6C0qTlBCXW43NjtX
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 5 Jun 2012 09:40:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
In-Reply-To: <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206050939140.26918@router.home>
References: <20120501132409.GA22894@lizard> <20120501132620.GC24226@lizard> <4FA35A85.4070804@kernel.org> <20120504073810.GA25175@lizard> <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com> <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
 <20120507121527.GA19526@lizard> <4FA82056.2070706@gmail.com> <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com> <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com> <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
 <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, KOSAKI Motohiro wrote:

> 4) Currently, vmstat have per-cpu batch and vmstat updating makes 3
> second delay at maximum.

Nope. The delay is one second only and it is limited to a certain amount
per cpu. There is a bound on the inaccuracy of the counter. If you want to
have them more accurate then the right approach is to limit the
threshhold. The more accurate the higher the impact of cache line
bouncing.

