Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab0EEKGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:06:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab0EEKGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:06:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100505032033.GA19232@google.com>
References: <20100505032033.GA19232@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@google.com>,
       Linux-MM <linux-mm@kvack.org>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
Date: Wed, 05 May 2010 11:06:44 +0100
Message-ID: <22994.1273054004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> and looks like it's doable with the x86 rwsem implementation as well in a
> way that would only involve changes to the rwsem spinlock-protected slow
> paths in lib/rwsem.c .

It's not as easy as it seems.  Once an XADD-based rwsem is contended, you
cannot necessarily tell without looking at the queue whether the rwsem is
currently write-locked or read-locked.

David
