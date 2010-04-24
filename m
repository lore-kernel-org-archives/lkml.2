Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0DXAc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:32:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47790 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0DXAc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:32:57 -0400
Message-ID: <50d28d42d9f97dd6444c54265de9cd4b.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1790.1272037936@redhat.com>
References: <20100424002319.d68a3819.toshi.okajima@jp.fujitsu.com>
    <20100423195127.48095127.toshi.okajima@jp.fujitsu.com>
    <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
    <7894.1271931370@redhat.com>
    <20100423194547.3135efb8.toshi.okajima@jp.fujitsu.com>
    <10934.1272022437@redhat.com> <1790.1272037936@redhat.com>
Date: Sat, 24 Apr 2010 09:32:54 +0900 (JST)
Subject: Re: [PATCH 1/1][BUG][TAKE2] KEYRINGS: find_keyring_by_name() can
 gain the freed keyring
From: =?ISO-2022-JP?B?GyRCMixFaCEhPHc5VBsoQg==?= 
	<toshi.okajima@jp.fujitsu.com>
To: "David Howells" <dhowells@redhat.com>
Cc: "Toshiyuki Okajima" <toshi.okajima@jp.fujitsu.com>, dhowells@redhat.com,
       keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
>
>> > Better still, atomic_inc_not_zero().  How about the attached patch?
>> Your fix looks good to me. But, if usage count of the keyring is 0,
>> I think it better to return -ENOKEY immediately.
>

> The problem with that is that someone else may have created a keyring with
> the
> same name that you can't then reach until the dead keyring is deleted.

OK. I understand.
---
Once find_keyring_by_name() returns -ENOKEY, the new user creates a
new key. So, both the deleting key and the new key may exist.
Therefore at next find_keyring_by_name() call, we should find the new
key and ignore the deleting key.
---

Toshiyuki Okajima

