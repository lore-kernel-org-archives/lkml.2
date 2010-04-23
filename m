Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0DWPw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab0DWPwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:52:25 -0400
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
Date: Fri, 23 Apr 2010 16:52:16 +0100
Message-ID: <1790.1272037936@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> > Better still, atomic_inc_not_zero().  How about the attached patch?
> Your fix looks good to me. But, if usage count of the keyring is 0,
> I think it better to return -ENOKEY immediately. 

The problem with that is that someone else may have created a keyring with the
same name that you can't then reach until the dead keyring is deleted.

David
