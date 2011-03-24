Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1CXQ5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:57:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48231 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1CXQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:57:45 -0400
Date: Thu, 24 Mar 2011 09:57:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, axboe@kernel.dk
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] PGPGIN underflow?
Message-Id: <20110324095735.61bfa370.randy.dunlap@oracle.com>
In-Reply-To: <20110324105307.1AF3.A69D9226@jp.fujitsu.com>
References: <20110324105307.1AF3.A69D9226@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D8B7802.00CE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 10:52:54 +0900 (JST) KOSAKI Motohiro wrote:

> Hi all,
> 
> Recently, vmstast show crazy big "bi" value even though the system has
> no stress. Is this known issue?
> 
> Thanks.

underflow?  also looks like -3 or -ESRCH.

Adding Jens in case he has any idea about it.

> 
> % vmstat 1
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  1  0      0 1133060 151336 479708    0    0     0     0   50   50  0  0 100  0  0
>  1  0      0 1133060 151336 479708    0    0     0     0   35   30  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   27   24  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   29   26  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   26   22  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   27   24  0  0 100  0  0
>  1  0      0 1133060 151336 479708    0    0     0     0   45   49  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   62   54  1  0 99  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   54   56  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   28   24  0  1 99  0  0
>  1  0      0 1133060 151336 479708    0    0     0     0   54   54  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   42   38  0  1 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   31   24  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   33   24  0  0 100  0  0
>  1  0      0 1133060 151336 479708    0    0     0     0   56   58  1  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0  157  225  1  0 98  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   40   37  0  0 100  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0   51   47  0  0 100  0  0
>  1  0      0 1133060 151336 479708    0    0     0     0   51   46  1  0 99  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0  296  418  2  0 97  0  0
>  0  0      0 1133060 151336 479708    0    0     0     0  295  419  3  2 95  0  0
>  0  0      0 1133060 151336 479708   16    0     0     0  313  449  3  1 96  0  0
>  0  0      0 1132936 151336 479708    0    0 4294967293     0  331  448  5  1 95  0  0
>  1  0      0 1132936 151336 479708    0    0     0     0  303  445  3  1 96  0  0
>  0  0      0 1132936 151336 479708   16    0     0     0  308  433  3  1 96  0  0
>  0  0      0 1132936 151336 479708    0    0     0     0  307  450  4  0 96  0  0
>  1  0      0 1132936 151344 479704   96    0     0     0  255  222  6  1 93  0  0
>  1  0      0 1132812 151344 479708    0    0 4294967293     0  397  310 11  1 88  0  0
>  0  0      0 1132688 151344 479708    0    0 4294967293     0  410  365  9  1 90  0  0
>  1  0      0 1132812 151344 479708    0    0     3     0   33   32  0  0 100  0  0
>  0  0      0 1132812 151344 479708    0    0     0     0   31   23  0  0 100  0  0
>  0  0      0 1132812 151344 479708    0    0     0     0   35   34  0  0 100  0  0
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
