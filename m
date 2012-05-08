Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2EHOCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:02:51 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:39906 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755220Ab2EHOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:02:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aEAhbQ4VM1noChxj6035kJCeyqT7X34cn8HgMkDM7l0OhTz
 nGZS1Qt6kkIgMR1xI8Gsg9Cj5jK54swDq1rBqXG1lLA3kiyQ9K1NCacsfqhK
 m8Y__z6bdOjRZG41W1G3y87OhVqb_E.eRMK0qPYNSi.ea.rQAll9d6SuS_Hd
 9haj9UrBA_DqbCMgE_qXc1JFzw_E35ZtNo7AQgLp.GPXh.v40ATrNQPeBCRN
 jO0Sbhfe9SM9wszh_fIM3ILzpDYSTouDl8T1M7fzQF8cWU0vXYFTpArmBUI4
 oOz6o5MNr5tRO5vHg08_WWtNvEC2GaX_oHCyiS0Nf8Sj4rjTIrp1S3AZfHlQ
 47QWN2K5owb7hfqQanuwPMU2WS5FzfAfYQVlUqNVXn42OC5WLb5UcFWYnNXp
 ER_VYoFkUeFKIGwd_2vbotGMxsN5iFYe.ov55Ktw72Jn2aEriH3KGp6NwWnN
 gtn0Adm1yk7QNtLRXkJK7DYV3Sm66Xkrqut5y4w7D
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 09:02:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: =?ISO-8859-2?Q?Robert_=A6wi=EAcki?= <robert@swiecki.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmap/clone returns ENOMEM with lots of free memory
In-Reply-To: <CAP145piK2kW4F94pNdKpo_sGg8OD914exOtwCx2o+83jx5Toog@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205080859570.25669@router.home>
References: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com> <alpine.DEB.2.00.1205071514040.6029@router.home> <CAP145piK2kW4F94pNdKpo_sGg8OD914exOtwCx2o+83jx5Toog@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1884713895-1336485767=:25669"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1884713895-1336485767=:25669
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 May 2012, Robert =C5=9Awi=C4=99cki wrote:

> Yup (btw: I attached dump of some proc files and some debug commands
> in the original e-mail - can be found here
> http://marc.info/?l=3Dlinux-kernel&m=3D133640623421007&w=3D2 in case some
> MTA removed them)
>
> CommitLimit:     1981528 kB
> Committed_AS:    1916788 kB
>
> just not sure if Committed_AS should present this kind of value. Did I
> just hit a legitimate condition, or may it suggest a bug? I'm a bit
> puzzled cause

This is a legitimate condition. No bug.
>
> root@ise-test:/proc# grep Mem /proc/meminfo
> MemTotal:        3963060 kB
> MemFree:         3098324 kB

Physical memory is free in quantity but virtual memory is exhausted.

> Also, some sysctl values:
> vm.overcommit_memory =3D 2
> vm.overcommit_ratio =3D 50

Setting overcommit memory to 2 means that the app is strictly policed
for staying within bounds on virtual memory. Dont do that.

See linux source linux/Documentation/vm/overcommit-accounting for more
details.


---1463811839-1884713895-1336485767=:25669--
