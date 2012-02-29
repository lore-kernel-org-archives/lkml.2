Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2B2UdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:33:10 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:38300 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754283Ab2B2UdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:33:09 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rVvrmwUVM1mpwJIUtu54TUdRon1zJWDzBUVhNwXuPgbZppj
 dBI4BMjEOj_L7EjtoNl.kILJz4dEL9lZNhq.SNyWVqKklsGVyLc2c9z_ul5_
 CUpX1Apx1fCUIQtqq4eQyeKG9Th9PpK1n9gAu2vkSIHTX33Q0MiC0XIW.OL0
 6t4VXD6MTXOwwu1IVMogBVEcxRGV4X4PYmyBVAt927nea_CeQ1W7ncKW4sHH
 una_6m0dycLn3EgnXE9ymc6J.bkJUyHBsm1y87Lg.REqxz_3M6a6LNzM5IWH
 uQI9Xrn43Fq3lI8Gc5a6QlE5gq4IpNi9EN6vLT8VF3VMDyFQ2WE.lla_gZe4
 bm5zDirc8bVm36sXQeB5s5bKDhTxCTW2Ye.PVcAR7615uFz2nZ3ucLHBeQ9.
 Hf93GAN7aHVJT6ZuIj6Hqjqr.fCu_NoRKT0Qn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 29 Feb 2012 14:33:06 -0600 (CST)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <20120229123120.127e21fd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1202291432350.6746@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202241131400.3726@router.home> <87sjhzun47.fsf@xmission.com> <alpine.DEB.2.00.1202271238450.32410@router.home> <87d390janv.fsf@xmission.com> <alpine.DEB.2.00.1202271636230.6435@router.home> <alpine.DEB.2.00.1202281329190.25590@router.home>
 <20120229123120.127e21fd.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Andrew Morton wrote:

> What was the user-visible impact of the bug?

THis was an oops reported by Dave Hansen after he inserted some loops in
the code to trigger a race condition.
