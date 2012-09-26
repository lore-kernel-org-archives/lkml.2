Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2IZWeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:34:14 -0400
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:30586 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752877Ab2IZWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:34:12 -0400
X-Yahoo-Newman-Id: 586922.18037.bm@omp1013.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ylBC394VM1miIW1MGjtUbP4vnDkRwUoh6P_3pQvoh.Trk6e
 LW.7xAw53ZD0UYAJDGC_ukobP_3IoZqrr3HCKMSgxujvCDDpNmst0IEjQcN5
 ICfHablxFXwbXuAwyRUdkFE.xwBlOT.LkmODinF114JOKHbZTj.4BFaR.15r
 PnN7YweZYVqKRigZJlWj.VNkSdvLwsTvrB7Z0GYQXX6GG2.rvSv16tH4kbYc
 vyI_SvlosINV1vMuMju9Zpt9HcW3ZP.gT0cZAy08AaQDd00jMApZO4PSwE8U
 9AEyZMpqf_DVsDAfXszhbxJDVyFrl0_glsaYurBBdkBsUnrEU7EvnMUaXp_N
 FmAjYQFUhm4Bf2AyIA.hu5gXYAGDAlJaD3zjM8XphnH19miYShdXIWR59Po6
 iAD1hphTEMJB3FTe8PU6CAVHck6rwSRkymQgk7PsNFuWcsld4iqCKAohXD9A
 UPCPI2zaRn8ts8HT0_VZNV3HoNGpnOwRi9ZRzPCJFTtJvB5TibhxENMjNd_v
 3Y0Fsa_7WVGIIpWWJZBZ2skTgHAh4V_qPXXHEwQ2S5YkW8uVAorpofFSk8gF
 .e0psTollVhIoL50Mo4G8SwlSnX.9QaCoSA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <506382E3.3020102@att.net>
Date: Wed, 26 Sep 2012 17:34:11 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3 2/9] rbtree: add __rb_change_child() helper function
References: <1345500331-10546-1-git-send-email-walken@google.com> <1345500331-10546-3-git-send-email-walken@google.com> <20120820151710.eeed9bcf.akpm@linux-foundation.org>
In-Reply-To: <20120820151710.eeed9bcf.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to resurrect the dead here, but I'm playing catch-up and this
looks important.

On 08/20/2012 05:17 PM, Andrew Morton wrote:
> I'm inclined to agree with Peter here - "inline" is now a vague,
> pathetic and useless thing.  The problem is that the reader just
> doesn't *know* whether or not the writer really wanted it to be
> inlined.
>
> If we have carefully made a decision to inline a function, we should
> (now) use __always_inline.
Are we all aware here that __always_inline (a.k.a.
"__attribute__((always_inline))") just means "inline even when not
optimizing"?  This appears to be a very common misunderstanding (unless
the gcc docs are wrong, see
http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html#index-g_t_0040code_007bflatten_007d-function-attribute-2512).

If you want to *force* gcc to inline a function (when inlining is
enabled), you can currently only do it from the calling function by
adding the |flatten attribute to it, which I have proposed adding here:
https://lkml.org/lkml/2012/9/25/643.

Thus, all of the __always_inline markings we have in the kernel only
affect unoptimized builds (and maybe -O1?).  If we need this feature
(and I think it would be darned handy!) we'll have to work on gcc to get it.

Daniel
|
