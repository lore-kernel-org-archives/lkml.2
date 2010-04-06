Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab0DFSxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab0DFSw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:52:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100406170903.GH5288@laptop>
References: <20100406170903.GH5288@laptop> <23428.1270570789@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: An incorrect assumption over radix_tree_tag_get()
Date: Tue, 06 Apr 2010 19:52:45 +0100
Message-ID: <25610.1270579965@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> It is safe. Synchronization requirements for using the radix tree API
> are documented.

I presume you mean the big comment on it in radix-tree.h.

According to that, it is not safe:

 * - any function _modifying_ the tree or tags (inserting or deleting
 *   items, setting or clearing tags) must exclude other modifications, and
 *   exclude any functions reading the tree.
 
David
