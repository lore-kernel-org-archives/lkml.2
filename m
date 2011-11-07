Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1KGXdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:33:19 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:51208 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab1KGXdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:33:17 -0500
X-AuditID: 1209190c-b7f806d0000008d6-75-4eb86abcf9c5
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in fill_super and remount.
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
Date: Mon, 7 Nov 2011 18:33:14 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E08B31F5-C43D-4145-BC38-C1C967CDD18E@MIT.EDU>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com> <20111107151939.GA24234@thunk.org> <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42IR4hTV1t2TtcPP4Gm7hcX1u7eYLWbOu8Nm
	cXnXHDYHZo+ds+6ye3zeJBfAFMVlk5Kak1mWWqRvl8CVsaHxPFvBVq6KkxM7GRsYn7N3MXJy
	SAiYSDz7tZsRwhaTuHBvPVsXIxeHkMA+RonZaz6zgiSEBNYzSnw94QxhH2WSmDKFE8QWFkiR
	uHvvMBuIzStgLLHm1jsWEJtZQEvixr+XTCA2m4CSxJ1P+8HinAKBEou37gabySKgIvHt7Wqg
	xRxA9ckSc5daQ7RqSyxb+JoZYqSVxNfL/cwQ96xmlDj2YRvY0SICahL7tkxkhjhaXqLl6x22
	CYyCs5CcMQvJGbOQzF3AyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI11AvN7NELzWldBMjOIwl
	eXYwvjmodIhRgINRiYd3pugOPyHWxLLiytxDjJIcTEqivHMzgEJ8SfkplRmJxRnxRaU5qcWH
	GCU4mJVEeEVCgXK8KYmVValF+TApaQ4WJXHegzsc/IQE0hNLUrNTUwtSi2CyMhwcShK8pzOB
	GgWLUtNTK9Iyc0oQ0kwcnCDDeYCG96eCDC8uSMwtzkyHyJ9i1OXobrx2ilGIJS8/L1VKnJcP
	mECEBECKMkrz4ObA0s8rRnGgt4R52UCqeICpC27SK6AlTEBL2nW3gSwpSURISTUwFtRG/Zjk
	v9n/QCdryIrFe+bVm/6Qcdis7Kz+56Lr/pBFd2bwBJ98YCSzeu/Ct0qdyT8uHzkZPen+MfEX
	sxwCbimclxXS+LacOfvbhsnSi+om+p/8FOa5pHnlXosHGc5dntuYP32If1jedUs4omGZ8gPr
	aymRHMEydZ4LQu6eYenmcfTxfZXyVImlOCPRUIu5qDgRAEJmcncaAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 7, 2011, at 6:06 PM, NamJae Jeon wrote:

>  if(data) {
>                orig_data = kstrdup(data, GFP_KERNEL);
>                if(!orig_data)
>                        return ret;
>        }

As I said earlier, the use of kstrdup() in the ext4 mount code is so that we can print the mount options used in the mount request.   So if the kstrdup() fails, the worst that will happen is that the printk will print the the mount had no mount options, instead of the mount options which had been passed this might be misleading, but it's not the end of the world; it's only a cosmetic issue.  But if the kstrdup() failed, the other memory allocations (that in general will be for much more memory) will also fail, so the mount will return ENOMEM before ever getting to the printjk.   So a pendant might make the above change, but in practice it's not really that important to do that particular checking in this case.

This is why it's important to really understand the code in question instead of just posting patches without understanding the underlying code, and understanding what might or might not go wrong both before applying the patch, and after applying the patch.   And of course, testing all of the use cases is also really important.

Best regards,

-- Ted

