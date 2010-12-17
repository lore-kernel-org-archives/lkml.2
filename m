Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0LQUCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:02:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582Ab0LQUCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:02:05 -0500
Date: Fri, 17 Dec 2010 12:02:34 -0800 (PST)
Message-Id: <20101217.120234.59681524.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: kirill@shutemov.name, netdev@vger.kernel.org, pablo@netfilter.org,
        ldv@altlinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix gcc -Wconversion compilation warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1sjy1uzj6.fsf@fess.ebiederm.org>
References: <1292259913-9911-1-git-send-email-kirill@shutemov.name>
	<m1sjy1uzj6.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Dec 2010 13:35:25 -0800

> "Kirill A. Shutsemov" <kirill@shutemov.name> writes:
> 
>> From: Dmitry V. Levin <ldv@altlinux.org>
>>
>> $ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
>> unsigned f(void) {return NLMSG_HDRLEN;}
>> EOF
>> <stdin>: In function 'f':
>> <stdin>:3:26: warning: negative integer implicitly converted to unsigned type
>>
> This doesn't look like a bad fix, but I believe things will fail if
> we give NLMSG_ALIGN an unsigned long like size_t.  Say like sizeof.

What are you talking about? That's exactly his test case,
look at what NLMSG_HDRLEN is defined to, it's exactly the
case you're worried "will fail", it passes sizeof() to
NLMSG_ALIGN.

I think I'll apply Kirill's original patch, it's good enough
and simpler.
