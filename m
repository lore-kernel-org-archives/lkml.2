Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1KKOnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:43:20 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:28985 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751602Ab1KKOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:43:17 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: O_2xtfcVM1li.UvtE7_mD17hDG8XE.SrC6r7u5YI9cyJ4bK
 z_L5_FiGMHrFeUpwhRAS8xX3_pg2_SdP1lE6vy.gHoizoHPeWGGSgy0jSNxH
 fcSXHZLqxxlK0hFvmSF4Qp6pX_UifAlHcwiv_93GMb2A2A4ipxKkevi5jwxZ
 _BstJx4gjheT0P0PHHqMjm4naUzvwugCaSI9tFzTAKuFAgSWIHaO_ML9ayub
 7_vmMth9qmbhseLXrB.ZurGbYPIqYqALY0NQle_E15f3a322AkVDQpYf7BoN
 q6ZWWYp4lvbCuCNQ.Y0fNM4SZunHKkdnCRK1NXiODoQtWOKoaLjslSMsPbK6
 Sy7iLgeV_i9tqrFPgg.bxi8NeIfO.IioE602ovrgmedHxic1yh8ZIGf22jp2
 4zxQ6YYvUyAHERIVHwIrL8Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 Nov 2011 08:43:13 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, cl@gentwo.org
Subject: Re: 3.2-rc1: INFO: possible recursive locking detected
In-Reply-To: <20111110234717.GI2354@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1111110841470.3006@router.home>
References: <20111109090556.GA5949@zhy> <20111110234717.GI2354@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Paul E. McKenney wrote:

> On Wed, Nov 09, 2011 at 05:05:57PM +0800, Yong Zhang wrote:
> > Hi,
> >
> > Just get below waring when doing:
> > for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done
> >
> > And kernel config is attached.
>
> This appears to me to be the same false positive from the slab allocator
> that has been seen before.  Christoph, any progress on this?

No this is another issue because it is not SLAB but SLUB. Must be a bug
introduced by the recent merges of the per cpu partial list support.
