Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2EGUgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:36:38 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:45726 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932180Ab2EGUgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:36:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XPnsbq8VM1nJ2XFRjesqy7BxsqDaUYa8dZHeg0d5Ra0YNoh
 pipOe2eEZcDXYulFntylkLO7jZfUDqr749hBmivKyOuqwE9Ey9YdVmveR0XX
 RcXpE.x5FaFyyzIV6iPb5MoNTcb8RegX1neF6oIfS05c6MY2u9tPqaJjEQGK
 XqaKMLPqadaesPK2lKodcsC_96Qs1sueBzW8tP7zRyXCyqYgXDRHxAvDCFiS
 S8dmiXu974RB7lPH9FfXuoiQXSWnJsyJ4viyAm4sbLB85gARMVOGmiw8Misw
 6QrfP7cmst39XTxNZFxQBvp_HuG4s5cD7daC4nzwk0POCDkX671r.D11l5CP
 pRevphF0CoLhzz38K4FNjzEeFvSSUX7T9sMxd.R3Qit.QGyFsRtepCUNHwU6
 bPO2nQKAe_qu4_0GnwRdXKqWidCJpoo4tqG9IgnVL.1TA
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 7 May 2012 15:15:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: =?ISO-8859-2?Q?Robert_=A6wi=EAcki?= <robert@swiecki.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmap/clone returns ENOMEM with lots of free memory
In-Reply-To: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205071514040.6029@router.home>
References: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=047d7b10c86d14f88404bf744902
Content-ID: <alpine.DEB.2.00.1205071514041.6029@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--047d7b10c86d14f88404bf744902
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1205071514042.6029@router.home>

On Mon, 7 May 2012, Robert =C5=9Awi=C4=99cki wrote:

> root@ise-test:~/kern-fuz# ./cont.sh
> su: Cannot fork user shell
> su: Cannot fork user shell
> su: Cannot fork user shell
>
> root@ise-test:~/kern-fuz# strace -e mmap,clone su test -c 'kill -CONT
> -1' 2>&1 | grep "=3D \-1"
> clone(child_stack=3D0,
> flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
> child_tidptr=3D0x7fadf334f9f0) =3D -1 ENOMEM (Cannot allocate memory)
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) =3D -1 ENOMEM (Cannot allocate memory)

Hmmm... That looks like some maximum virtual memory limit was violated.

Check ulimit and the overcommit settings (see /proc/meminfo's commitlimit
etc)

--047d7b10c86d14f88404bf744902--
