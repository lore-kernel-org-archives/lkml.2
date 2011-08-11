Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1HKPNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:13:49 -0400
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:41283 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598Ab1HKPNq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:13:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 381556.66591.bm@omp1028.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KWASSWk3yEJxb9RuRvLtp4fzAhkNJcinYFTeJm2Opn9goLYZ2LpRsOpgS5XKLkpCsQcP8dyBjvvg1EUaYUXNCacEaH7Gvve05olVdOtgkZacLh4Yt6riyCG0omIADRW9jIuaVjHEQ96XCpEvc+HBm1+k6cQazhGbZXksR21KZ/g=;
X-YMail-OSG: blxmxnwVM1no_3yHlr7pJymNW3_Y15r1h2sPrD9mayuAffD
 Hlq.CX6_ShMI1x2ld073.cDD_5XelmBppewzoEKOVn7RxdvxGCFTmPcaYR1o
 BOW8V4zAgcIYlLs8s9bgtUMr5eKBGeD_k1nJbVrC2LJ5ViAEa4iENK9qvhoj
 D2s8EWNYAy_qcNTX0.lJtHwtGzNFhvuM_3Nm0kI7HQ14_RTlvJ_puR0gsJyM
 lALtNYC1t.3Ooqe9Vyai3Hj3Uy_i8vX1W1_sE.09lz7jguvTXS288HKrsM6r
 rP1V0LIXKGwd91oiUOqh0LluQnC7b3ddPWcNGHm9iPq_8dGrcqJPNZ_ubR_v
 Qej6uQXutaHg9ZQ8RHHR2iaUHzUhMBajsD47IrmcX_MRfFMmMI.Mt8Escnrl
 s1fXkusa9LGb_C_iXgtADB5CbXfRaTFCLJ4Nnz3nchrTHbfCfQ21L0hlwH.N
 md5E9
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com> <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com> <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108110010220.23622@chino.kir.corp.google.com> <1313049724.11241.YahooMailNeo@web111704.mail.gq1.yahoo.com> <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
Message-ID: <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
Date: Thu, 11 Aug 2011 08:13:45 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>What it can possibly do if there is no swap and therefore it 

>can't free memory by writing out RAM pages to swap?


>the disk activity comes from constant paging in (reading)
>of pages which contain code of running binaries.

Why the disk activity does not appear in the first scenario?


>Thus the only option is to find some not recently used page
> with read-only, file-backed content (usually some binary's 

>text page, but can be any read-only file mapping) and reuse it.
Why "killing" does not appear here? Why it try to "find some 

recently used page"?


Both scenarios have one common thing... Running out of memory.
But they behave differently.


// Naderan *Mahmood;


________________________________
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: David Rientjes <rientjes@google.com>; Randy Dunlap <rdunlap@xenotime.net>; """"linux-kernel@vger.kernel.org"""" <linux-kernel@vger.kernel.org>; """linux-mm@kvack.org""" <linux-mm@kvack.org>
Sent: Thursday, August 11, 2011 5:17 PM
Subject: Re: running of out memory => kernel crash

On Thu, Aug 11, 2011 at 10:02 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>>Despite it's name, kswapd is still active, it's trying to reclaim memory
>>to prevent having to kill a process as the last resort.
>
> I understand what you said, but I did two scenarios:
> 1- I wrote a simple C++ program that "new" a lot of pointers.
>    for ( int i = 0; i < n; i++ ) {
>      for ( int j = 0; j < n; j++ ) {
>        for ( int k = 0; k < n; k++ ) {
>          for ( int l = 0; l < n; l++ ) {
>            double *ptr1 = new double[n*i];
>            double *ptr2 = new double[n*j];
>      }}}}
>
> When I run the program, it ill eat the memory and when it reaches the
> maximum ram, it get killed and I saw  message on terminal:
>
> mahmood@vpc:~$ ./leak
> Killed
>
> for this scenario, there is no kswapd process running.

Why do you think kswapd should get active? What it can possibly do
if there is no swap and therefore it can't free memory by writing
out RAM pages to swap?

> 2- There is 300MB ram. I opened an application saw that
> free space reduced to 100MB, then another application reduced the free
> space to 30MB. Another application reduced to 4MB. Now the "kswapd"
> is running with a lot of disk activity and tries to keep free space at 4MB.
> In this scenario, No application is killed.
>
> The question is why in one scenario, the application is killed and in one
> scenario, kswapd is running.

In scenario 2, the disk activity comes from constant paging in (reading)
of pages which contain code of running binaries.

Since machine has no free RAM and no swap at all, when it needs
a free page it can't swap out a dirty (modified) page or anon
(usually malloced space) page. Thus the only option is to find some
not recently used page with read-only, file-backed content (usually some
binary's text page, but can be any read-only file mapping) and reuse it.

If there are no really old, unused read-only, file-backed pages,
then the discarded page will be needed soon, will need to be read from disk,
and will evict another similar page. Which will be needed soon too,
will need to be read from disk, and will evict another such page...
ad infinitum.

-- 
vda 
