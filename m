Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0DFQUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:20:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0DFQUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:20:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: paulmck@linux.vnet.ibm.com, npiggin@suse.de, corbet@lwn.net
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-cachefs@redhat.com
Subject: An incorrect assumption over radix_tree_tag_get()
Date: Tue, 06 Apr 2010 17:19:49 +0100
Message-ID: <23428.1270570789@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I think I've made a bad assumption over my usage of radix_tree_tag_get() in
fs/fscache/page.c.

I've assumed that radix_tree_tag_get() is protected from radix_tree_tag_set()
and radix_tree_tag_clear() by the RCU read lock.  However, now I'm not so
sure.  I think it's only protected against removal of part of the tree.

Can you confirm?

David
