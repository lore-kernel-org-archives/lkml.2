Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2FRG2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:28:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62053 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2FRG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7t_7UtjkuZaQRhnj99Y_eRcHLRLmqXOaiGTi4tHwGB4MHsgg@mail.gmail.com>
References: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
	<1339914285.7349.75.camel@marge.simpson.net>
	<CANQmPXikSJfms9n2vNugw=+7fijyRem3RHqWfCCM=XcBXDSU6A@mail.gmail.com>
	<CAK7t_7UtjkuZaQRhnj99Y_eRcHLRLmqXOaiGTi4tHwGB4MHsgg@mail.gmail.com>
Date: Mon, 18 Jun 2012 14:28:08 +0800
Message-ID: <CANQmPXgqeERy55LtwO8a-bZAnSacW7bdL_o3jQkne+aGxUOVMg@mail.gmail.com>
Subject: Re: [PATCH][ANNOUNCE]RIFS-ES Scheduling V1 release.
From: Chen <hi3766691@gmail.com>
To: Vikram Dhillon <opensolarisdev@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:01 AM, Vikram Dhillon
<opensolarisdev@gmail.com> wrote:
> On Sun, Jun 17, 2012 at 6:24 PM, Chen <hi3766691@gmail.com> wrote:
>> Sorry for my fault.
>> The patch has build issue and I post the new one.
>
> Hi Chen,
>
> It is always very interesting to see new scheduler designs however can
> you shows us some benchmarks? How does this compare to CFS currently?
> Also how well does it scale beyond desktops?
>
> - Vikram


Here is the benchmark result(Latency) for RIFS-ES and CFS(I have done
them with computer and I am posting them with my Android phone now)

RIFS-ES
========================================
[root@localhost admin]# latt -c1 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=1
Entries logged: 27

Wakeup averages
-------------------------------------
	Max		      25 usec
	Avg		      10 usec
	Stdev		       3 usec
	Stdev mean	       1 usec

Work averages
-------------------------------------
	Max		   20265 usec
	Avg		   20100 usec
	Stdev		      82 usec
	Stdev mean	      16 usec
[root@localhost admin]# latt -c2 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=2
Entries logged: 54

Wakeup averages
-------------------------------------
	Max		     824 usec
	Avg		      30 usec
	Stdev		     117 usec
	Stdev mean	      16 usec

Work averages
-------------------------------------
	Max		   21472 usec
	Avg		   20486 usec
	Stdev		     190 usec
	Stdev mean	      26 usec
[root@localhost admin]# latt -c4 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=4
Entries logged: 104

Wakeup averages
-------------------------------------
	Max		   20423 usec
	Avg		    2343 usec
	Stdev		    3810 usec
	Stdev mean	     374 usec

Work averages
-------------------------------------
	Max		   41037 usec
	Avg		   36096 usec
	Stdev		    4247 usec
	Stdev mean	     416 usec
[root@localhost admin]# latt -c8 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=8
Entries logged: 184

Wakeup averages
-------------------------------------
	Max		   71284 usec
	Avg		    6112 usec
	Stdev		    9640 usec
	Stdev mean	     711 usec

Work averages
-------------------------------------
	Max		   83043 usec
	Avg		   68615 usec
	Stdev		   10615 usec
	Stdev mean	     783 usec
[root@localhost admin]# latt -c16 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=16
Entries logged: 320

Wakeup averages
-------------------------------------
	Max		   35669 usec
	Avg		    9690 usec
	Stdev		    8961 usec
	Stdev mean	     501 usec

Work averages
-------------------------------------
	Max		  166790 usec
	Avg		  136161 usec
	Stdev		   30660 usec
	Stdev mean	    1714 usec


RIFS-ES: Total result for wake up average latency:
-c1:
	Avg		      10 usec
-c2:
	Avg		      30 usec
-c4:
	Avg		    2343 usec
-c8:
	Avg		    6112 usec
-c16:
	Avg		    9690 usec

CFS
========================================
[root@localhost ~]$ latt -c1 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=1
Entries logged: 27

Wakeup averages
-------------------------------------
	Max		      40 usec
	Avg		      21 usec
	Stdev		       8 usec
	Stdev mean	       2 usec

Work averages
-------------------------------------
	Max		   20648 usec
	Avg		   20262 usec
	Stdev		      97 usec
	Stdev mean	      19 usec
[root@localhost ~]$ latt -c2 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=2
Entries logged: 54

Wakeup averages
-------------------------------------
	Max		      45 usec
	Avg		      19 usec
	Stdev		      10 usec
	Stdev mean	       1 usec

Work averages
-------------------------------------
	Max		   21549 usec
	Avg		   20495 usec
	Stdev		     320 usec
	Stdev mean	      43 usec
[root@localhost ~]$ latt -c4 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=4
Entries logged: 104

Wakeup averages
-------------------------------------
	Max		   20430 usec
	Avg		    4900 usec
	Stdev		    6274 usec
	Stdev mean	     615 usec

Work averages
-------------------------------------
	Max		   50538 usec
	Avg		   30564 usec
	Stdev		    6492 usec
	Stdev mean	     637 usec
[root@localhost ~]$ latt -c8 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=8
Entries logged: 184

Wakeup averages
-------------------------------------
	Max		   38195 usec
	Avg		    8068 usec
	Stdev		    8132 usec
	Stdev mean	     599 usec

Work averages
-------------------------------------
	Max		   83525 usec
	Avg		   67597 usec
	Stdev		   10037 usec
	Stdev mean	     740 usec
[root@localhost ~]$ latt -c16 sleep 10

Parameters: min_wait=100ms, max_wait=500ms, clients=16
Entries logged: 320

Wakeup averages
-------------------------------------
	Max		   83711 usec
	Avg		   17497 usec
	Stdev		   21219 usec
	Stdev mean	    1186 usec

Work averages
-------------------------------------
	Max		  166547 usec
	Avg		  119376 usec
	Stdev		   31758 usec
	Stdev mean	    1775 usec


CFS: Total result for wake up average latency:
-c1:
	Avg		      21 usec
-c2:
	Avg		      19 usec
-c4:
	Avg		    4900 usec
-c8:
	Avg		    8068 usec
-c16:
	Avg		   17497 usec
