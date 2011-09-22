Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1IVRnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:43:15 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:34331 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1IVRnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:43:13 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr>
	<1316702729.4849.114.camel@sauron>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 22 Sep 2011 19:42:59 +0200
In-Reply-To: <1316702729.4849.114.camel@sauron> (Artem Bityutskiy's message of
	"Thu, 22 Sep 2011 17:45:21 +0300")
Message-ID: <87mxdwiicc.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> Could you please re-base your driver on top of my l2 tree and fix
> warnings 0 I get the following:
Of course.

> BTW, the next step I'd do is to try to compile it with sparse, so you
> could test this driver with sparse: Documentation/sparse.txt
OK.

>> +#define doc_flashSequence(seq)						\
>> +do {									\
>> +	doc_dbg("doc_flashSequence: %02x " #seq "\n", DoC_Seq_##seq);	\
>> +	doc_writeb(DoC_Seq_##seq, DoC_FlashSequence);			\
>> +} while (0)
>> +
...zip...
>
> Could you please turn these macros into 'static inline' function - this
> is one of the modern patterns of kernel programming - we try to use
> functions for better type checking.
No sorry, that I cannot. If you look closely, the ##seq is not something you can
convert with an inline function, neither the #seq.

-- 
Robert
