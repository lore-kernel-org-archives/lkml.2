Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1AYOfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:35:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1AYOfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:35:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295883437.2156.1.camel@offworld>
References: <1295883437.2156.1.camel@offworld>
To: Davidlohr Bueso <dave@gnu.org>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        keyrings@linux-nfs.org
Subject: Re: [PATCH] security: keyring: remove redundant NULL check
Date: Tue, 25 Jan 2011 14:35:40 +0000
Message-ID: <29992.1295966140@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave@gnu.org> wrote:

> -	if (prealloc) {
> -		kfree(prealloc);
> -		key_payload_reserve(keyring,
> -				    keyring->datalen - KEYQUOTA_LINK_BYTES);
> -	}
> +	kfree(prealloc);
> +	key_payload_reserve(keyring,
> +			keyring->datalen - KEYQUOTA_LINK_BYTES);
> +

This is not correct, since you'd be removing the quota allocation for the new
link in the case that __key_link() was called (and cleared *_prealloc).

However, the upstream code isn't correct either, since the preallocation may
not have extended the reservation at all (if it decided to displace a key
rather than adding a key).

David
