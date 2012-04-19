Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2DSNsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:48:41 -0400
Received: from nm25-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.156]:43726 "HELO
	nm25-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755357Ab2DSNsj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:48:39 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 09:48:39 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 424787.28912.bm@omp1063.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2iTGnRDTjeUQoreXmAy7pby9IoF6sXhBBINHKraq0DV9BnPC7kqso5j+NgIfyrL///aWH4Fu7mjmsIcxxAQbF/JaycYXCdUgqbkg8r7RfxW/4sP9nAf6glfKHAx5hEbNBhSxuctDWG64pGNsQ4MsUHlVa72b0tHTCbo5pPnYd4o=;
X-YMail-OSG: FuXIpUoVM1mpiwhmUXJWPmQ.aF7mSE7LKbPkEOUtd9Cr3aW
 NtssjWuJbnR7A6SE7veZxBwAStUewKN3_V8X7ND1bWzqQZUMgY6qCcU4GzuG
 HG2dZnSwba.11r0zcdQMHwQ1q6H_aavTZpMkb6kcojM_UuLOaEqZDxnLcy22
 E3_xS_pEPKIqnooZHPV2dmMSEMbkXCG1fXBOle4QrkhJRU7eOJSoIvazix9K
 7FV5ASjZKFiOFQ46oBCmY7LsDyu1LSGKFZq5VGtkqIOXy9DlCuOT.6ibqfaH
 .abdDruGbylgmNkW_q63024.zehz4pA83kGc1uJoOFfM8r3Y_wcYrfdOsJDz
 AhH5SdCCHh.F6.aiABf2wwfBlrGd.ZA1tMRkdTX4an6EW.o8a.5BKxq_Lwqk
 AKrKRlzyl1QR3wNv4X7GNHnaYvgduYpI2aYHky86WiU_zjso6tB6yB9XvyV2
 YUrtYFygwp5WsMybksL5M9ySZTDFv5892yVZ.8J0LotgvUH5FtBmEsp4-
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com> <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com> <1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com> <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com> <20120418211032.47b243da@pyramind.ukuu.org.uk>
Message-ID: <1334842941.92324.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Thu, 19 Apr 2012 06:42:21 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
In-Reply-To: <20120418211032.47b243da@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>________________________________
>From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>To: richard -rw- weinberger <richard.weinberger@gmail.com>  
>Sent: Thursday, 19 April 2012 1:40 AM
>Subject: Re: [NEW]: Introducing shrink_all_memory from user space
>
>On Sun, 15 Apr 2012 14:10:00 +0200
>richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>
>> On Sun, Apr 15, 2012 at 1:47 PM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
>> > Moreover, this is mainly meant for mobile phones where there is only *one* user.
>> 
>> I see. Jet another awful hack.
>> Mobile phones are nothing special. They are computers
>
>Correct - so if it is showing up useful situations then they are also
>useful beyond mobile phone.
>
>> Every program which is allowed to use this interface will (ab)use it.
>
>If you expose it to userspace then you would want it very tightly
>controlled and very much special case. Within the kernel using it
>internally within things like CMA allocators seems to make more sense.
>
>I think you overestimate the abuse. It's an interface which pushes clean
>pages that can be cheaply recovered out of memory. It doesn't guarantee
>the caller reaps the benefit of that, and the vm will continue to try and
>share out any new resource fairly.
>
>Alan

Dear Alan, thank you very much for your comments and suggestion.
My plan is to develop a kind of system utility (like defragment) which we can run from user space (as root).
 
And yes you are right, my future plan is also to use it for CMA as it also suffers from memory fragmentation.
Now I think CMA uses memory compaction solution to reclaim pages for its allocation. Similarly we can use this on top of compaction for better results.
 
And we can even call this from low memory notifier whenever memory pressure falls below watermark and regain memory state as it was before.
 
Well more experiments and findings are in progress.
 
 
 
Thanks,
Pintu
