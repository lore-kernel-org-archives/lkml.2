Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0DZK5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:57:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0DZK5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:57:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100424002319.d68a3819.toshi.okajima@jp.fujitsu.com>
References: <20100424002319.d68a3819.toshi.okajima@jp.fujitsu.com> <20100423195127.48095127.toshi.okajima@jp.fujitsu.com> <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com> <7894.1271931370@redhat.com> <20100423194547.3135efb8.toshi.okajima@jp.fujitsu.com> <10934.1272022437@redhat.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][BUG][TAKE2] KEYRINGS: find_keyring_by_name() can gain the freed keyring
Date: Mon, 26 Apr 2010 11:57:36 +0100
Message-ID: <26383.1272279456@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> And my previous figure description(in first patch) was a bit wrong. 
> Please replace it with my new one:

The spacing is all over the place, I'm afraid.  Can you send it again?

For example, the vertical bars in the right-hand column don't align:

|  [spin_lock(&key_serial_lock)]      |[mutex_lock(&key_user_keyr..mutex)]
|  |                                       ||
|  atomic_read() == 0                 ||
|  |{ rb_ease(&key->serial_node,) }   ||
|  |                                       ||
|  [spin_unlock(&key_serial_lock)]    |find_keyring_by_name()
|  |                                       |||

David
