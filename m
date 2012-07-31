Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GaOCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab2GaOCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:02:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120731130314.24441.85882.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120731130314.24441.85882.stgit@ltc137.sdl.hitachi.co.jp>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: dhowells@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] sysctl: fix improper indication of integer sysctl parameter
Date: Tue, 31 Jul 2012 15:02:05 +0100
Message-ID: <5498.1343743325@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:

> When we read the sysctl parameter, they are always treated
> as signed integer, and are casted into unsigned long type
> in the current kernel. If we set a value equivalent to
> (the maximum value in signed integer + 1)

Wouldn't it be better to return EINVAL or EDOM?

David
