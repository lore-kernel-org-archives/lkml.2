Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1HQIup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:50:45 -0400
Received: from nm12-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.51]:39743 "HELO
	nm12-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751443Ab1HQIul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:50:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 84411.4661.bm@omp1029.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0kcjnRi1e+Mctq7tYmAkTgZSEkowUlADXPmVdSAJH3oRUYlELomHLLeTy00fIdaZ1rJGYkPkYT/E8oNodsyd3sfHj9JpfAVdAreukBVoPr+Sk13zk0NpG5d0HVGTCSzK/3Ey2IIFGXrQ5EcvU0vYnngUcY6kpVx+8JGPboQrLr8=;
X-YMail-OSG: x.wTfGgVM1lHoI.kvQwiedPwVEEcsIMXQd_3bCXC.gVc_me
 Tslpa_Q.7JEbRsepfwktpXbea0ANeUqpa82vVqPMq3dVl_ZVqUULxjfLrYco
 zi9u5Iif2vj2RrP6GiGBsiT_D86tkqcVc6S0pbAIMkGNoUHzLwQ8EWWMzuuK
 67aa3HTygidsH.zrTLIC2gQ71LmVBEa79tIsm6olkPD6Nr2mhvdzA4GlqC6u
 WENrznewZGBPZs_rpKEHp83AZ9dEUvzwlAGy68.wDu2zJRdUwRuRLmD4fZD3
 TWvsWaDEWqNhVAzt6spjCH9YfkoTuscM1pBXgsy_Hiuw5dshtkOUZEItLQ9A
 xagM.FN4eB6dqA_Ao_nzqeSev1M_RU8WVciwuC_ajJLVLk0QqGQFcQujfH70
 TtHP2z9MAFBp0bTmxX3u3DKoB0Wa8vokc3ac6EU6g1MrT5gWMh5Rv_HwLhob
 KzO7g_A--
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com> <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com> <201108111938.25836.vda.linux@googlemail.com>
Message-ID: <1313571040.71372.YahooMailNeo@web111710.mail.gq1.yahoo.com>
Date: Wed, 17 Aug 2011 01:50:40 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "\"\"linux-kernel@vger.kernel.org\"\"" <linux-kernel@vger.kernel.org>,
        "\"\"linux-mm@kvack.org\"\"" <linux-mm@kvack.org>
In-Reply-To: <201108111938.25836.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Denys for your indepth response

 
// Naderan *Mahmood;


----- Original Message -----
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: David Rientjes <rientjes@google.com>; Randy Dunlap <rdunlap@xenotime.net>; ""linux-kernel@vger.kernel.org"" <linux-kernel@vger.kernel.org>; ""linux-mm@kvack.org"" <linux-mm@kvack.org>
Sent: Thursday, August 11, 2011 10:08 PM
Subject: Re: running of out memory => kernel crash

On Thursday 11 August 2011 17:13, Mahmood Naderan wrote:
> >What it can possibly do if there is no swap and therefore it 
> 
> >can't free memory by writing out RAM pages to swap?
> 
> 
> >the disk activity comes from constant paging in (reading)
> >of pages which contain code of running binaries.
> 
> Why the disk activity does not appear in the first scenario?

Because there is nowhere to write dirty pages in order to free
some RAM (since you have no swap) and reading in more stuff
from disk can't possibly help with freeing RAM.

(What kernel does in order to free RAM is it drops unmodified
file-backed pages, and doing _that_ doesn't require disk I/O).

Thus, no reading and no writing is necessary/possible.


> >Thus the only option is to find some not recently used page
> > with read-only, file-backed content (usually some binary's 
> 
> >text page, but can be any read-only file mapping) and reuse it.
> Why "killing" does not appear here? Why it try to "find some 
> 
> recently used page"?

Because killing is the last resort. As long as kernel can free
a page by dropping an unmodified file-backed page, it will do that.
When there is nothing more to drop, and still more free pages
are needed, _then_ kernel will start oom killing.

-- 
vda

