Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1KSVOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 16:14:09 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:46582 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992Ab1KSVOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 16:14:07 -0500
X-AuditID: 12074423-b7f266d0000008b8-a0-4ec81c1e9ecc
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAKYAXd91gcPbfAqRRkW7HhxRDXstzGVRbwqzve40z6BTDEj4_w@mail.gmail.com>
Date: Sat, 19 Nov 2011 16:14:01 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2F5A5082-690F-4C74-A92F-6CC157489B46@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu> <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com> <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com> <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com> <8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu> <A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu> <CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com> <0912364C-C313-4BCA-9EE2-73F55FE012E6@mit.edu> <CAKYAXd91gcPbfAqRRkW7HhxRDXstzGVRbwqzve40z6BTDEj4_w@mail.gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42IRYrdT15WTOeFn8Pgbl0Xz6gdMFtfv3mK2
	mDnvDpvF5V1z2CzalmxkcmD12DnrLrvHgk2lHp83yQUwR3HZpKTmZJalFunbJXBlfF71nqXg
	LWvF7Cf7WRsYj7B0MXJySAiYSMzuPcYIYYtJXLi3nq2LkYtDSGAfo8Tlj4cYIZwNjBJf3r2E
	ck4zSZzd+gSsXVjAReLRt9dg7bwCxhJrbr0DizMLaEnc+PeSCcRmE1CSuPNpP1icUyBQ4umz
	2ewgNouAqkTblglg65gF9jJKHN11lAmiWVti2cLXzBBDrSQa5u6G2nyZRWLjxJNgRSICahL7
	tkxkhjhcXqLl6x22CYyCs5AcMgvJIbOQzF3AyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI10wv
	N7NELzWldBMjONRdlHcw/jmodIhRgINRiYe3cMYxPyHWxLLiytxDjJIcTEqivP1iJ/yE+JLy
	UyozEosz4otKc1KLDzFKcDArifBGcQDleFMSK6tSi/JhUtIcLErivDI7HfyEBNITS1KzU1ML
	UotgsjIcHEoSvHXSQI2CRanpqRVpmTklCGkmDk6Q4TxAw5NAaniLCxJzizPTIfKnGBWlxHk7
	QBICIImM0jy4XlgqesUoDvSKMG8KSBUPMI3Bdb8CGswENDh3zxGQwSWJCCmpBsad7rfj1j+e
	sP6YD2elQrlh/NyHbFfj/Rm02yTm8Gz8uc3Cn/W72dxr12et8zEpLT1t89NrYk/FOpGkiA2L
	bT4XLnz9Ne+jywcXCc4MSaHAHeyHzq7+F1cc3tP+ut11u8XlwnoB5V+/dHW7ZMXdSqdE2yZ/
	Tan6t1BRZ//t28q77U77P9535Y0SS3FGoqEWc1FxIgC4DTq3IAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 19, 2011, at 10:40 AM, NamJae Jeon wrote:

> Thanks for your opinion.
> Have you thought that mem spread flags is not needed in group info
> caches same with page_io and mballoc ?

The group info structures are long lived structures that live a long time and will likely be accessed by many NUMA nodes.   So setting the men spread flag for the group info cache is more likely to be useful.   My guess is that any benefit will be extremely hard to measure (especially since the amount of memory used by the group info structures is a pittance compared to the memory used by the inode cache), but at least theoretically it would be sound to have that flag set with the group info slab cache.

Regards,

-- Ted

