Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab0LNQ4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:56:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab0LNQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:56:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: don't check cfqg in choose_service_tree()
References: <4D070F7C.3060503@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Dec 2010 11:56:29 -0500
In-Reply-To: <4D070F7C.3060503@cn.fujitsu.com> (Gui Jianfeng's message of
	"Tue, 14 Dec 2010 14:32:28 +0800")
Message-ID: <x49mxo88f9e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:

> When cfq_choose_cfqg() is called in select_queue(), there must be at least one
> backlogged CFQ queue waiting for dispatching, hence there must be at least one
> backlogged CFQ group on service tree. So we never call choose_service_tree()
> with cfqg == NULL.

Further, if cfqg was NULL, cfq_choose_cfqg would have dereferenced a
NULL pointer and we wouldn't even get to choose_service_tree.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
