Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2KUJ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:59:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33558 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KUJ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:58:58 -0500
X-AuditID: cbfee610-b7fd06d000005bdb-4b-50aca5e0a068
Date: Wed, 21 Nov 2012 09:58:56 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: opp_get_notifier() needs to be under rcu_lock?
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121121095844517@myungjoo.ham
Msgkey: 20121121095844517@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121121095844517@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5729011.20441353491935757.JavaMail.weblogic@epml17>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zHd0HS9cEGLz5KGFxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy1rz5wFzwi6XicvdklgbGJyxdjJwcQgLqEouWnGQDsSUETCRm
	fe1jgrDFJC7cWw8U5wKqWcYocXj2OxaYottHHzFCNM9nlLh9nBnEZhFQlWjsbmbvYuTgYBPQ
	k5j5ORkkLCxgLXH/+TWwmSJAu5bP3QnWyiwQIfFsehcbxBgliTX7XoGN5xUQlDg58wnUKlWJ
	o8f3QMXVJI7euMcKEZeQmDX9ApTNKzGj/SlUvZzEtK9rmCFsaYnzszYwwvyy+PtjqDi/xLHb
	O5hAzgTpfXI/GGbM7s1foMEgIDH1zEFGiBItibUT7CDCfBJrFr5lgZmy69RyZpjW+1vmMkF8
	pSgxpfshO4StJfHlxz42dF/xCjhIfL53nHUCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJBcVJ6
	qplecWJucWleul5yfu4mRkhKENjBuKTB4hCjAAejEg+vxL7VAUKsiWXFlbmHGCU4mJVEeDdN
	WRMgxJuSWFmVWpQfX1Sak1p8iNEHGH0TmaVEk/OB6SqvJN7Q2MDY0NDS0MzU0tQAh7CSOC97
	xfQAIYH0xJLU7NTUgtQimHFMHJxSDYzlFbl1E2Uvro3atEIygT/iav+Cp2ptLn2/dc7felEk
	z/rs/eWMGZ/22YWxXW/kaOvZdtOV4UmWobz3foPDYjaVp6VXnZhz4KSv3/xL95wyviWyKq5P
	Cnm9dNa6UL3fq54ss+I/Zm+f0anAlRAiXVb96c28s9+bfj58eNyjYfbxz7HCP3sbr2QosRRn
	JBpqMRcVJwIAZ5avnzYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t/tmboPlq4JMPg7VcTi8q45bA6MHp83
	yQUwRmXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAN
	VVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKkUbGRjrGZma6BkZG+iZGMRaGRoYGJkCVSVk
	ZKx584G54BdLxeXuySwNjE9Yuhg5OYQE1CUWLTnJBmJLCJhI3D76iBHCFpO4cG89G0TNfEaJ
	28eZQWwWAVWJxu5m9i5GDg42AT2JmZ+TQcLCAtYS959fYwKxRYBGLp+7E2wMs0CExLPpXVBj
	lCTW7HsFtpZXQFDi5EyIEySARh49vgcqriZx9MY9Voi4hMSs6RegbF6JGe1PoerlJKZ9XcMM
	YUtLnJ+1Ae7kxd8fQ8X5JY7d3sEEciZI75P7wTBjdm/+AvWtgMTUMwcZIUq0JNZOsIMI80ms
	WfiWBWbKrlPLmWFa72+ZywTxlaLElO6H7BC2lsSXH/vY0H3FK+Ag8fnecdYJjHKzkKRmIWmf
	haQdWc0CRpZVjKKpBckFxUnpqWZ6xYm5xaV56XrJ+bmbGMHJ6ZnADsYlDRaHGAU4GJV4eCX2
	rQ4QYk0sK67MPcQowcGsJMK7acqaACHelMTKqtSi/Pii0pzU4kOMPsDom8gsJZqcD0yceSXx
	hsYGxoaGluYGpoZGFjiElcR52SumBwgJpCeWpGanphakFsGMY+LglGpgNPfIDkgR/7D/husR
	88vfltcELNOYsNK2rMtH/Pjnd/UrPMS5ehtnvPTfVbo02Fx4/9c8i132lj/6nNfzZkxe+qeg
	OjhJpWnTwT0yWcWyRXJ3NA+ta/G5JL9u87eIkulrf6ZZ/9T46VxymS1b58CF5PUyfNLiuikH
	0oPf9UneTqv2FOCf2VKqxFKckWioxVxUnAgARUBLQnsDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAL9x6H5029022

> Hi,
> 
> It looks like find_device_opp() (called from opp_get_notifier()) needs
> to be under RCU read lock, but this doesn't seem to be happening in
> drivers/devfreq/devfreq.c. Doesn't this run the risk of referencing a
> freed variable?
> 
> Thanks,
> 
> -Kees

Yes, that's an issue requiring updates.

Thank you for pointing out.



Cheers,
MyungJoo

> 
> -- 
> Kees Cook
> Chrome OS Security
> 


       
  
         

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
