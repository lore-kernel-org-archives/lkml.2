Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0DVKQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0DVKQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:16:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
References: <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][BUG][IMPORTANT] KEYRINGS: find_keyring_by_name() can gain the freed keyring
Date: Thu, 22 Apr 2010 11:16:10 +0100
Message-ID: <7894.1271931370@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> With linux-2.6.34-rc5, find_keyring_by_name() can gain the keyring which has
> been already freed. And then, its space (which is gained by
> find_keyring_by_name()) is broken by accessing the freed keyring as the
> available keyring.

Good catch!

I'm not sure this is the best solution, though.

The alternative is just to ignore keys that have a zero usage count.

David
