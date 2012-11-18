Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2KRPox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:44:53 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:34851 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260Ab2KRPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:44:52 -0500
From: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Sun, 18 Nov 2012 17:43:07 +0200
Message-ID: <1380367.3QOKJVXxFC@lx-vladimir>
Organization: Qualcomm
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1353249531.15959.10.camel@joe-AO722>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <3304277.iqgq3GH3Yo@lx-vladimir> <1353249531.15959.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 18, 2012 06:38:51 AM Joe Perches wrote:
> Another option could be testing __builtin_constant_p(prefix)

You mean something like below? Yes, it will work as well.

Pro: don't need to change existing code 
(drop [PATCH 2/2] dynamic_debug: use constant format in print_hex_dump_bytes())

Cons: format in dynamic metadata will be useless

What looks better?

---
#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
			 groupsize, buf, len, ascii)		\
do {								\
	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, 		\
		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
		print_hex_dump(KERN_DEBUG, prefix_str,		\
			       prefix_type, rowsize, groupsize,	\
			       buf, len, ascii);		\
} while (0)



