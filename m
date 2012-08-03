Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2HCP6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:58:44 -0400
Received: from seven.medozas.de ([5.9.24.206]:34505 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab2HCP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:58:39 -0400
Date: Fri, 3 Aug 2012 17:58:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: "Steven J. Magnani" <steve@digidescorp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
In-Reply-To: <87lihw10cs.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LNX.2.01.1208031734550.7170@frira.zrqbmnf.qr>
References: <1341314074-2867-1-git-send-email-steve@digidescorp.com> <alpine.LNX.2.01.1208031650580.3676@frira.zrqbmnf.qr> <87lihw10cs.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-08-03 17:06, OGAWA Hirofumi wrote:
>>>+static inline unsigned char fat_tolower(unsigned char c)
>>>+{
>>>+	return ((c >= 'A') && (c <= 'Z')) ? c+32 : c;
>>>+}
>>>+
>>
>> The kernel already has a tolower() function, can that not be used?
>
>tolower() is not exactly same, right? e.g. tolower(0xc0). Otherwise,
>tolower() is fine.

Yes, but you can still

	return (c >= 'A' && c <= 'Z') ? tolower(c) : c;
